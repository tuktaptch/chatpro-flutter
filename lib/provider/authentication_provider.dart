import 'dart:convert';
import 'dart:io';

import 'package:chat_pro/authentication/otp/otp_screen.dart';
import 'package:chat_pro/constraints/constants.dart';
import 'package:chat_pro/models/user_model.dart';
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

  // ดึงข้อมูลผู้ใช้งานจาก Firestore
  Future<void> fetchUserDataFromFireStore() async {
    final userDoc = await _firestore
        .collection(Constants.users) // collection ของผู้ใช้งาน
        .doc(_uid) // document ตาม UID
        .get(); // ดึงข้อมูล document
    // if (userDoc.exists) {
    // ถ้า document มีอยู่
    _userModel = UserModel.fromMap(
      userDoc.data() as Map<String, dynamic>,
    ); // แปลง
    notifyListeners(); // แจ้ง UI รีเฟรช
    // }
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
      _isLoading = false; // โหลดเสร็จ แม้ล้มเหลว
      _isSuccessful = false; // สถานะล้มเหลว
      notifyListeners(); // แจ้ง UI

      if (context.mounted) {
        // ตรวจสอบ context ก่อนใช้งาน
        showSnackBar(context, e.toString(), Type.failed); // แสดงข้อความผิดพลาด
      }
    }
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูลผู้ใช้ลง Firebase Firestore
  // และอัปโหลดรูปภาพไป Firebase Storage หากมี
  Future<void> saveUserDataToFirebase({
    required UserModel userModel, // ข้อมูลผู้ใช้ที่จะบันทึก
    required File? fileImage, // ไฟล์รูปภาพผู้ใช้ (อาจเป็น null)
    required Function onSuccess,
    required Function onFail,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // ตรวจสอบว่าผู้ใช้มีรูปภาพหรือไม่
      if (fileImage != null) {
        String imageUrl = await storeFileToStorage(
          file: fileImage,
          reference: '${Constants.userImages}/${userModel.uid}',
        );

        // บันทึก URL รูปภาพลงใน userModel
        userModel.image = imageUrl;
      }
      userModel.lastSeen = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();

      _userModel = userModel; // เก็บข้อมูลผู้ใช้ใน provider
      _uid = userModel.uid; // เก็บ UID ของผู้ใช้

      // บันทึกข้อมูลผู้ใช้ลง Firestore
      // collection: users
      // document id: uid ของผู้ใช้
      await _firestore
          .collection(Constants.users)
          .doc(userModel.uid)
          .set(userModel.toMap()); // แปลง userModel เป็น Map ก่อนบันทึก

      _isLoading = false;
      onSuccess(); // เรียก callback เมื่อสำเร็จ
      notifyListeners();
    } on FirebaseException catch (e) {
      if (e.message != null) {
        onFail(e.message);
      } else {
        onFail('Something went wrong. Please try again later.');
      }
    } catch (e) {
      onFail('Something went wrong. Please try again later.');
    }

    _isLoading = false;
    notifyListeners();
  }

  //store file to storage and return file url.
  Future<String> storeFileToStorage({
    required file,
    required String reference,
  }) async {
    UploadTask uploadTask = _storage.ref().child(reference).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String fileUrl = await snapshot.ref.getDownloadURL();
    return fileUrl;
  }

  //get user stream
  Stream<DocumentSnapshot> usersStream({required String uid}) {
    return _firestore.collection(Constants.users).doc(uid).snapshots();
  }
}
