import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_share/constants/app_constants.dart';

class AppName extends StatelessWidget {
  const new({super.key, this.fontSize, this.removeR, this.fontWeight});
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? removeR;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: removeR ?? false ? "ide" : "Ride",
        style: GoogleFonts.outfit(
          fontSize: fontSize ?? 30,
          fontWeight: fontWeight ?? .bold,
          color: AppConstColors.secondary,
        ),
        children: [
          TextSpan(
            text: "Share",
            style: TextStyle(color: AppConstColors.accent),
          ),
        ],
      ),
    );
  }
}
