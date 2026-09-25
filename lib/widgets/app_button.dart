import 'package:flutter/material.dart';
import 'package:rider_share/constants/app_constants.dart';

class AppMainButton extends StatelessWidget {
  const AppMainButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
    this.isLoading = false,
    this.mainColor,
    this.isOutlined = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? mainColor;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = mainColor ?? AppConstColors.secondary;

    final Color contentColor = isOutlined ? buttonColor : Colors.white;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.transparent : buttonColor,

        foregroundColor: contentColor,

        // Disabled colors
        disabledBackgroundColor: isOutlined
            ? Colors.transparent
            : buttonColor.withValues(alpha: .6),

        disabledForegroundColor: contentColor.withValues(alpha: .6),

        side: isOutlined
            ? BorderSide(color: buttonColor, width: 1.5)
            : BorderSide.none,

        padding: const EdgeInsets.symmetric(vertical: 14),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

        // No shadow
        elevation: 0,
        shadowColor: Colors.transparent,

        // Press feedback
        overlayColor: buttonColor.withValues(alpha: .12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!
                .copyWith(color: contentColor, fontWeight: .w300),
          ),

          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: contentColor,
                strokeWidth: 2,
              ),
            )
          else
            Icon(icon, color: contentColor),
        ],
      ),
    );
  }
}
