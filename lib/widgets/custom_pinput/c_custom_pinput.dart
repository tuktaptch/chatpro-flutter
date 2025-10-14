import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_shadow.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/widgets/custom_pinput/c_custom_pinput_controller.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class CPinPut extends StatelessWidget {
  /// Controller สำหรับจัดการสถานะต่างๆ ของ PinPut
  /// เช่น การล้างค่า, การตั้งสถานะ error หรือ verify
  final CPinPutController controller;

  /// ความยาวของรหัสผ่าน (จำนวนหลัก)
  /// ค่าเริ่มต้นคือ 6 หลัก
  final int length;

  /// Callback เมื่อกรอกรหัสผ่านครบถ้วน
  /// โดยจะส่งค่ารหัสผ่านที่กรอกมาเป็น String
  final void Function(String)? onCompleted;

  const CPinPut({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // กำหนด theme ของ pin แต่ละ state
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: CTypography.body1.copyWith(
        color: CColors.darkGray,
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        color: CColors.pureWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: CShadow.defaultShadow,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      textStyle: CTypography.body1.copyWith(
        color: CColors.hotPink,
        fontSize: 22,
      ),
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: CColors.hotPink, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme;

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: CColors.red, width: 2),
      ),
    );
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<CPinPutController>(
        builder: (context, provider, _) {
          return Pinput(
            onTap: () => provider.focusNode.requestFocus(),
            controller: provider.controller,
            focusNode: provider.focusNode,
            length: length,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            errorPinTheme: errorPinTheme,
            showCursor: true,
            onCompleted: onCompleted,
            autofocus: true,
          );
        },
      ),
    );
  }
}
