import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:flutter/material.dart';

class NoDataContainer extends StatelessWidget {
  const NoDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.width * 0.2; // responsive icon (20% ของความกว้างจอ)

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: iconSize.clamp(50, 100), // จำกัดไม่ให้ใหญ่หรือเล็กเกินไป
            color: CColors.grayBlue.withAlpha(120),
          ),
          ConstSpacer.height12(),
          Text(
            'No data',
            style: CTypography.title.copyWith(
              color: CColors.grayBlue.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}
