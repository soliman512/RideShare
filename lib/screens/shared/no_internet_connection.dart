import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/screens/app_scaffold.dart';

class NoInternetConnection extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isChecking;

  const NoInternetConnection({
    super.key,
    required this.onRetry,
    required this.isChecking,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 20,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                AppConstImages.noInternetConnection,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            spacing: 4,
            children: [
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppConstColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Unable to connect to the server. Please check your internet connection and try again.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppConstColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          AppMainButton(
            onPressed: onRetry,
            title: isChecking ? 'Checking...' : 'Try again',
            icon: Remix.wifi_line,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
