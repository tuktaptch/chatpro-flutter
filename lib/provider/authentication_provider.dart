import 'dart:convert';
import 'dart:io';

import 'package:chat_pro/ui/authentication/otp/otp_screen.dart';
import 'package:chat_pro/constraints/constants.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/utilities/alert/alert.dart';
import 'package:chat_pro/utilities/alert/toast_item.dart';
import 'package:chat_pro/utilities/firebase_storage_util.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  UserModel? get userModel => _userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //check authentication state
  Future<bool> checkAuthenticationState() async {
    bool isSignedIn = false;
    await Future.delayed(Duration(seconds: 2));
    if (_auth.currentUser != null) {
      _uid = _auth.currentUser!.uid;

      //get user from firestore
      await fetchUserDataFromFireStore();

      //save user data to share preferences
      await saveUserDataToSharedPreference();
      notifyListeners();
      isSignedIn = true;
    } else {
      isSignedIn = false;
    }
    return isSignedIn;
  }

  // ตรวจสอบว่าผู้ใช้งานมีอยู่ในระบบหรือไม่
  Future<bool> checkUserExists() async {
    // ดึงข้อมูล document ของผู้ใช้งานจาก Firestore ตาม UID
    final userDoc = await _firestore
        .collection(Constants.users) // collection ของผู้ใช้งาน
        .doc(_uid) // document ตาม UID
        .get(); // ดึงข้อมูล document

    // คืนค่า true ถ้า document มีอยู่, false ถ้าไม่มี
    return userDoc.exists;
  }

  Future<void> fetchUserDataFromFireStore() async {
    try {
      final userDoc = await _firestore
          .collection(Constants.users)
          .doc(_uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        debugPrint('⚠️ User document not found for UID: $_uid');
        return;
      }

      _userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      notifyListeners();
    } catch (e, stack) {
      debugPrint('❌ Error fetching user data: $e');
      debugPrint(stack.toString());
      Alert.show(stack.toString(), type: ToastType.failed);
    }
  }

  //save user data to shared preference.
  Future<void> saveUserDataToSharedPreference() async {
    // Implement saving user data to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //save user model to shared preference.
    await prefs.setString(Constants.userModel, jsonEncode(_userModel?.toMap()));
  }

  //load user data from shared preference.
  Future<void> loadUserDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userModelString = prefs.getString(Constants.userModel) ?? '';

    _userModel = UserModel.fromMap(jsonDecode(userModelString));
    _uid = _userModel?.uid;
    notifyListeners();
  }

  // ฟังก์ชันสำหรับลงชื่อเข้าใช้งานด้วยเบอร์โทรศัพท์
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    _isLoading = true; // เริ่มโหลด
    notifyListeners(); // แจ้ง UI ให้รีเฟรช

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, // เบอร์โทรผู้ใช้งาน
        // เรียกเมื่อ Firebase ตรวจสอบเบอร์สำเร็จทันที (auto-retrieval)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential); // ลงชื่อเข้าใช้โดยตรง
          _isSuccessful = true; // กำหนดสถานะสำเร็จ
          _uid = _auth.currentUser?.uid; // เก็บ UID ของผู้ใช้
          _phoneNumber = _auth.currentUser?.phoneNumber; // เก็บเบอร์โทรผู้ใช้

          _isLoading = false; // โหลดเสร็จ
          notifyListeners(); // แจ้ง UI รีเฟรช
        },

        // เรียกเมื่อการตรวจสอบเบอร์ล้มเหลว
        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false;
          _isSuccessful = false; // สถานะล้มเหลว
          notifyListeners(); // แจ้ง UI
          showSnackBar(
            context,
            e.message ?? '',
            Type.failed,
          ); // แสดงข้อความผิดพลาด
        },

        // เรียกเมื่อรหัส OTP ถูกส่งไปยังเบอร์ผู้ใช้แล้ว
        codeSent: (String verificationId, int? resendToken) {
          _isLoading = false;
          _isSuccessful = true; // ส่ง OTP สำเร็จ
          notifyListeners(); // แจ้ง UI

          // นำผู้ใช้ไปยังหน้ากรอกรหัส OTP
          Navigator.pushNamed(
            context,
            OtpScreen.routeName,
            arguments: OtpScreenArguments(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          );
        },

        // เรียกเมื่อรอ auto-retrieval timeout
        codeAutoRetrievalTimeout: (String verificationId) async {
          _isLoading = false;
          _isSuccessful = false; // สถานะล้มเหลว
          notifyListeners(); // แจ้ง UI

          // สำหรับ testing ใช้รหัส OTP ที่ตั้งไว้ใน console
          String smsCode = '123456';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );
          await FirebaseAuth.instance.signInWithCredential(
            credential,
          ); // ลงชื่อเข้าใช้
        },
      );
    } catch (e) {
      Alert.show(e.toString(), type: ToastType.failed);
      // จัดการ error ทั่วไป
      _isLoading = false;
      _isSuccessful = false;
      notifyListeners(); // แจ้ง UI
    }
  }

  // ฟังก์ชันสำหรับตรวจสอบรหัส OTP ที่ผู้ใช้กรอก
  Future<void> verifyOtpCode({
    required String verificationId, // verificationId จาก Firebase
    required String smsCode, // รหัส OTP ที่ผู้ใช้กรอก
    required BuildContext context,
    required Function onSuccess, // callback เมื่อยืนยันสำเร็จ
  }) async {
    _isLoading = true; // เริ่มโหลด
    notifyListeners(); // แจ้ง UI ให้รีเฟรช

    try {
      // สร้าง Credential จาก verificationId และ smsCode
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // ลงชื่อเข้าใช้ด้วย credential
      await _auth.signInWithCredential(credential);

      _isSuccessful = true; // สถานะสำเร็จ
      _uid = _auth.currentUser?.uid; // เก็บ UID ของผู้ใช้
      _phoneNumber = _auth.currentUser?.phoneNumber; // เก็บเบอร์โทรผู้ใช้
      _isLoading = false; // โหลดเสร็จ

      onSuccess(); // เรียก callback เมื่อสำเร็จ
      notifyListeners(); // แจ้ง UI รีเฟรช
    } catch (e) {
      Alert.show(e.toString(), type: ToastType.failed);
      _isLoading = false; // โหลดเสร็จ แม้ล้มเหลว
      _isSuccessful = false; // สถานะล้มเหลว
      notifyListeners(); // แจ้ง UI

      if (context.mounted) {
        // ตรวจสอบ context ก่อนใช้งาน
        showSnackBar(context, e.toString(), Type.failed); // แสดงข้อความผิดพลาด
      }
    }
  }

  // save user data to firestore
  void saveUserDataToFireStore({
    required UserModel userModel,
    required File? fileImage,
    required Function onSuccess,
    required Function onFail,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (fileImage != null) {
        // upload image to storage
        String imageUrl = await FirebaseStorageUtil.storeFileToStorage(
          file: fileImage,
          reference: '${Constants.userImages}/${userModel.uid}',
        );

        userModel.image = imageUrl;
      }

      userModel.lastSeen = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();

      _userModel = userModel;
      _uid = userModel.uid;

      // save user data to firestore
      await _firestore
          .collection(Constants.users)
          .doc(userModel.uid)
          .set(userModel.toMap());

      _isLoading = false;
      onSuccess();
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      onFail(e.toString());
    }
  }

  //get user stream
  Stream<DocumentSnapshot> usersStream({required String uid}) {
    return _firestore.collection(Constants.users).doc(uid).snapshots();
  }

  //get all user stream
  Stream<QuerySnapshot> getAllUsersStream({required String uid}) {
    return _firestore
        .collection(Constants.users)
        .where(Constants.uid, isNotEqualTo: uid)
        .snapshots();
  }

  //send friend request
  Future<void> sendFriendRequest({required String friendUID}) async {
    try {
      //add our uid to friend request list
      await _firestore.collection(Constants.users).doc(friendUID).update({
        Constants.friendRequestsUIDs: FieldValue.arrayUnion([_uid]),
      });
      //add friend uid to our friend request sent list
      await _firestore.collection(Constants.users).doc(_uid).update({
        Constants.sentFriendRequestsUIDs: FieldValue.arrayUnion([friendUID]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //cancel friend request
  Future<void> cancelFriendRequest({required String friendUID}) async {
    try {
      //remove our uid from friends request list
      await _firestore.collection(Constants.users).doc(friendUID).update({
        Constants.friendRequestsUIDs: FieldValue.arrayRemove([_uid]),
      });
      //remove friend uid from our friend requests sent list
      await _firestore.collection(Constants.users).doc(_uid).update({
        Constants.sentFriendRequestsUIDs: FieldValue.arrayRemove([friendUID]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //accept friend request
  Future<void> acceptFriendRequest({required String friendUID}) async {
    try {
      //add our uid to friends  list
      await _firestore.collection(Constants.users).doc(friendUID).update({
        Constants.friendsUIDs: FieldValue.arrayUnion([_uid]),
      });
      //add our uid to our  friends  list
      await _firestore.collection(Constants.users).doc(_uid).update({
        Constants.friendsUIDs: FieldValue.arrayUnion([friendUID]),
      });
      //remove our uid from friends request list
      await _firestore.collection(Constants.users).doc(friendUID).update({
        Constants.sentFriendRequestsUIDs: FieldValue.arrayRemove([_uid]),
      });
      //remove friend uid from our friend requests sent list
      await _firestore.collection(Constants.users).doc(_uid).update({
        Constants.friendRequestsUIDs: FieldValue.arrayRemove([friendUID]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //remove friend request
  Future<void> removeFriendRequest({required String friendUID}) async {
    try {
      //remove our uid from friends list
      await _firestore.collection(Constants.users).doc(friendUID).update({
        Constants.friendsUIDs: FieldValue.arrayRemove([_uid]),
      });
      //remove friend uid from our friend list
      await _firestore.collection(Constants.users).doc(_uid).update({
        Constants.friendsUIDs: FieldValue.arrayRemove([friendUID]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<List<UserModel>> getFriendsList({required String uid}) async {
    List<UserModel> friendList = [];

    try {
      // Get the current user's document
      DocumentSnapshot documentSnapshot = await _firestore
          .collection(Constants.users)
          .doc(uid)
          .get();

      // Extract the list of friend UIDs
      List<dynamic> friendUIDs = documentSnapshot.get(Constants.friendsUIDs);

      // Loop through each friend UID and fetch their details
      for (String friendUID in friendUIDs) {
        DocumentSnapshot friendSnapshot = await _firestore
            .collection(Constants.users)
            .doc(friendUID)
            .get();

        if (friendSnapshot.exists) {
          UserModel friend = UserModel.fromMap(
            friendSnapshot.data() as Map<String, dynamic>,
          );
          friendList.add(friend);
        }
      }
    } catch (e) {
      // Log the error and return an empty list if fetching fails
      print('Failed to get friends list: $e');
      return [];
    }

    return friendList;
  }

  Future<List<UserModel>> getFriendsRequestList({required String uid}) async {
    List<UserModel> friendRequestList = [];
    try {
      // Get the current user's document
      DocumentSnapshot documentSnapshot = await _firestore
          .collection(Constants.users)
          .doc(uid)
          .get();

      // Extract the list of friend UIDs
      List<dynamic> friendRequestUIDs = documentSnapshot.get(
        Constants.friendRequestsUIDs,
      );

      // Loop through each friend UID and fetch their details
      for (String friendRequestUID in friendRequestUIDs) {
        DocumentSnapshot friendSnapshot = await _firestore
            .collection(Constants.users)
            .doc(friendRequestUID)
            .get();

        if (friendSnapshot.exists) {
          UserModel friendRequest = UserModel.fromMap(
            friendSnapshot.data() as Map<String, dynamic>,
          );
          friendRequestList.add(friendRequest);
        }
      }
    } catch (e) {
      // Log the error and return an empty list if fetching fails
      print('Failed to get friends list: $e');
      return [];
    }
    return friendRequestList;
  }

  // update user status
  Future<void> updateUserStatus({required bool value}) async {
    await _firestore
        .collection(Constants.users)
        .doc(_auth.currentUser!.uid)
        .update({Constants.isOnline: value});
  }

  Future<void> logOut() async {
    // TODO: Implement logOut functionality.
    try {
      await _auth.signOut();

      // Clear locally stored user data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // _uid = null;
      // _phoneNumber = null;
      // _userModel = null;
      _isSuccessful = false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error during logout: $e');
    }
  }
}
