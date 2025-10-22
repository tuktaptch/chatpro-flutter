import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authProvider;

  PeopleScreenProvider(this._authProvider);

  String get currentUserId => _authProvider.userModel?.uid ?? '';

  /// Stream ของผู้ใช้ทั้งหมด ยกเว้น current user
  Stream<QuerySnapshot> get allUsersStream {
    return _authProvider.getAllUsersStream(uid: currentUserId);
  }

  /// ดึงข้อมูลจาก DocumentSnapshot เป็น Map
  Map<String, dynamic> parseUserData(QueryDocumentSnapshot document) {
    final rawData = document.data();
    if (rawData == null) return {};
    return rawData as Map<String, dynamic>;
  }
}
