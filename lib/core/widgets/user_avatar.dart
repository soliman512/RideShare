import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const new({super.key, required this.name, this.radius, this.mainColor, this.fontSize});
  final String name;
  final double? radius;
  final double? fontSize;
  final Color? mainColor;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 36,
      backgroundColor:
          mainColor?.withValues(alpha: .3) ??
          Colors.white.withValues(alpha: .3),

      child: Text(
        name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map(((e) => e[0]))
            .join()
            .toUpperCase(),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: mainColor ?? Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 20,
        ),
      ),
    );
  }
}
