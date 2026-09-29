import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstColors.primaryText.withValues(alpha: 0.28),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: .symmetric(horizontal: context.screenWidth * .2),
          padding: const .all(8),
          decoration: BoxDecoration(
            color: AppConstColors.surface,
            borderRadius: BorderRadius.circular(20),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: Image.asset(AppConstImages.loading, fit: .contain),
              ),

              Text(
                'Please wait a second...',
                textAlign: .center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstColors.primaryText,
                  fontWeight: .bold,
                ),
              ),

              const SizedBox(height: 12),

              // Text(
              //   'We are getting everything ready for you.',
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.bodyMedium
              //       ?.copyWith(color: Colors.black54, height: 1.4),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
