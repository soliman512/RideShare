import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_share/constants/app_constants.dart';

class DefaultBody extends StatelessWidget {
  const new({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.imageOpacity,
  });
  final String title;
  final String subtitle;
  final String imagePath;
  final double? imageOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Opacity(
          opacity: imageOpacity ?? .5,
          child: Image.asset(imagePath, fit: .cover, width: 350),
        ),
        Text(
          title,
          textAlign: .center,
          style: GoogleFonts.outfit(
            fontSize: 20,
            color: AppConstColors.primaryBlack,
            fontWeight: .w300,
          ),
        ),
        Text(
          subtitle,
          textAlign: .center,

          style: GoogleFonts.outfit(
            fontSize: 14,
            color: const Color.fromARGB(255, 156, 156, 156),
            fontWeight: .w300,
          ),
        ),
      ],
    );
  }
}
