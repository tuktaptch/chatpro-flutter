import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class CTypography {
  CTypography._(); // ป้องกันไม่ให้ new instance

  // Display (ใหญ่สุด)
  static final TextStyle display1 = GoogleFonts.pacifico(
    fontSize: 60,
    fontWeight: FontWeight.w400, // Regular
  );
  static final TextStyle display2 = GoogleFonts.workSans(
    fontSize: 44,
    fontWeight: FontWeight.w400, // Regular
  );

  // Heading
  static final TextStyle heading1 = GoogleFonts.workSans(
    fontSize: 28,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static final TextStyle heading2 = GoogleFonts.workSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle heading3 = GoogleFonts.pacifico(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Title
  static final TextStyle title = GoogleFonts.workSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body
  static final TextStyle body1 = GoogleFonts.workSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body2 = GoogleFonts.workSans(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
  );

  static final TextStyle body3 = GoogleFonts.workSans(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
  );

  // Caption
  static final TextStyle caption1 = GoogleFonts.workSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle caption2 = GoogleFonts.workSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Small
  static final TextStyle small = GoogleFonts.workSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
}
