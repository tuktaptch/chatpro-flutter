import 'package:flutter/material.dart';

class NavigationService {
  /// ใช้ key นี้ใน MaterialApp เพื่อให้สามารถอ้างอิง context ได้ทั่วแอป
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// ดึง BuildContext ปัจจุบันจาก navigatorKey
  ///
  /// หมายเหตุ: context จะเป็น null ถ้า widget tree ยังไม่ถูก build
  BuildContext? get context => navigatorKey.currentContext;
}
