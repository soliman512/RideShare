import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_constants.dart';

class DefaultBody extends StatelessWidget {
  const new({
    super.key,
    required this.imagePath,
    this.title,
    this.subtitle,
    this.imageOpacity,
  });
  final String? title;
  final String? subtitle;
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
        if (title != null)
          Text(
            title!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppConstColors.primaryText,
              fontWeight: FontWeight.w300,
            ),
          ),
        if (subtitle != null)
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromARGB(255, 156, 156, 156),
              fontWeight: FontWeight.w300,
            ),
          ),
      ],
    );
  }
}
