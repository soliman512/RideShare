import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/screens/app_scaffold.dart';

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Column(
        mainAxisSize: .max,
        children: [
          const Spacer(flex: 1),

          Image.asset(AppConstImages.oops, fit: BoxFit.contain),
          const SizedBox(height: 40),

          Text(
            'Something Went Wrong',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppConstColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'An unexpected error occurred. Please restart '
            'the application to continue.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppConstColors.secondaryText,
              height: 1.7,
            ),
          ),

          const Spacer(),

          AppMainButton(
            title: 'Restart Application',
            onPressed: () {
              Phoenix.rebirth(context);
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
