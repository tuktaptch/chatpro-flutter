import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/models/message_model.dart';
import 'package:chat_pro/utilities/date_time_extension.dart';
import 'package:flutter/material.dart';

/// ใช้สำหรับสร้าง widget แสดงวันที่ของแต่ละกลุ่มข้อความในหน้า Chat
Center buildChatDate(MessageModel element) {
  return Center(
    child: Card(
      color: CColors.pureWhite,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          element.timeSent.formattedDate(),
          textAlign: TextAlign.center,
          style: CTypography.body1.copyWith(color: CColors.darkGray),
        ),
      ),
    ),
  );
}
