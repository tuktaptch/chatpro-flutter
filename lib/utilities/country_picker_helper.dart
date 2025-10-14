import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';


/// ตัวกลางสำหรับเรียก Country Picker
/// [onCountrySelected] คือ callback เมื่อผู้ใช้เลือกประเทศ
void showCustomCountryPicker({
  required BuildContext context,
  required void Function(Country) onCountrySelected,
}) {
  showCountryPicker(
    context: context,
    showPhoneCode: true,
    countryListTheme: CountryListThemeData(
      backgroundColor: CColors.extraLight,
      searchTextStyle: CTypography.body1.copyWith(
        color: CColors.pastelPink,
        decorationColor: CColors.pastelPink,
      ),
      inputDecoration: InputDecoration(
        filled: true,
        fillColor: CColors.extraLight,
        hintText: 'Search...',
        hintStyle: CTypography.body2.copyWith(color: CColors.darkGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: CColors.hotPink),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: CColors.pastelPink),
        ),
      ),
    ),
    onSelect: onCountrySelected, // เรียก callback ที่รับมาจาก parameter
  );
}
