import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale từ `design_meteofocus/README.md §Design Tokens`.
abstract final class AppTextStyles {
  static TextStyle heroTemperature = GoogleFonts.beVietnamPro(
    fontSize: 50,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.03 * 50,
    height: 1,
    color: AppColors.textPrimary,
  );

  static TextStyle h1 = GoogleFonts.beVietnamPro(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.beVietnamPro(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle label = GoogleFonts.beVietnamPro(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle pomodoroDigits = GoogleFonts.beVietnamPro(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
