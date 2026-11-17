import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMainButton extends StatelessWidget {
  const AppMainButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.isLoading = false,
    this.mainColor,
    this.isOutlined = false,
    this.showDecoration = true,
    this.btnHeign,
    this.btnWidth,
    this.fontSize,
  });

  final IconData? icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showDecoration;
  final Color? mainColor;
  final bool isOutlined;
  final double? btnHeign;
  final double? btnWidth;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = mainColor ?? AppConstColors.secondary;

    final Color contentColor = isOutlined ? buttonColor : Colors.white;

    return SizedBox(
      height: btnHeign ?? 52.h,
      width: btnWidth ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : buttonColor,

          foregroundColor: contentColor,

          // Disabled colors
          disabledBackgroundColor: isOutlined
              ? Colors.transparent
              : buttonColor.withValues(alpha: .6),

          disabledForegroundColor: contentColor.withValues(alpha: .6),
          padding: .zero,
          side: isOutlined
              ? BorderSide(color: buttonColor, width: 1.5)
              : BorderSide.none,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          // No shadow
          elevation: 0,
          shadowColor: Colors.transparent,

          // Press feedback
          overlayColor: buttonColor.withValues(alpha: .12),
        ),

        child: Stack(
          children: [
            if (showDecoration) ...[
              Positioned(
                top: -20,
                bottom: -20,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: isOutlined
                      ? buttonColor.withValues(alpha: .16)
                      : AppConstColors.primary.withValues(alpha: .1),
                  radius: 40,
                ),
              ),
              Positioned(
                top: -10,
                bottom: -10,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: isOutlined
                      ? buttonColor.withValues(alpha: .16)
                      : AppConstColors.primary.withValues(alpha: .1),

                  radius: 30,
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  // Spacer(),
                  // SizedBox(width: 20),

                  FittedBox(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            color: contentColor,
                            fontWeight: .w300,
                            fontSize: fontSize,
                          ),
                    ),
                  ),
                  // Spacer(),
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: contentColor,
                        strokeWidth: 2,
                      ),
                    )
                  else ...[
                    icon != null
                        ? Icon(icon, color: contentColor)
                        : SizedBox.shrink(),
                    // SizedBox(width: 20),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
