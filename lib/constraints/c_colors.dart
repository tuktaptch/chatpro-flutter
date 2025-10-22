import 'package:flutter/material.dart';

class CColors {
  CColors._(); // this basically makes it so you can't instantiate this class

  /// Primary Colors
  static const hotPink = Color(0xFFFA2784);
  static const vividPink = Color(0xFFFA5186);
  static const pinkOrange = Color(0xFFFC6E88);
  static const pastelPink = Color(0xFFFC848A);
  static const salmonPink = Color(0xFFFC9E8C);
  static const lightPink = Color(0xFFFEDBE2);

  /// Neutral Colors
  /// Neutral Colors
  static const darkGray = Color(0xFF343639); // เข้มสุด
  static const grayBlue = Color(0xFF9CA6AE); // กลางเข้ม
  static const lightBlue = Color(0xFFD1D9ED); // กลาง
  static const veryLightBlue = Color(0xFFEDF2F5); // อ่อน
  static const paleBlue = Color(0xFFF1F6F8); // อ่อนมาก
  static const extraLight = Color(0xFFF7F9FA); // เกือบขาว
  static const pureWhite = Color(0xFFFFFFFF); // ขาวบริสุทธิ์
  static const pinkWhisper = Color(0xFFFFFAFB);
  static const chatLeftGray = Color(0xFFE4E6EB);


  /// Supplement Colors
  static const blue = Color(0xFF568EF5);
  static const green = Color(0xFF14C0BD);
  static const warning = Color(0xFFFEB719);
  static const orange = Color(0xFFFD9977);
  static const red = Color(0xFFF64E60);
  static const purple = Color(0xFF835DD7);

  // Gradient Colors
  static const hotPinkToPinkOrange = [hotPink, pinkOrange];
  static const pinkOrangeToLightPink = [pinkOrange, lightPink];

  // Background Colors
  static const background = Color(0xFFFDFBFB);
}
