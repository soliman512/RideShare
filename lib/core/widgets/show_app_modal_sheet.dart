import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';

Future<void> showAppModalSheet(
  BuildContext context, {
  required List<Widget> children,
  double spacing = 16,
}) async {
  await showModalBottomSheet(
    context: context,
    isDismissible: true,
    showDragHandle: false,
    enableDrag: true,
    barrierColor: AppConstColors.primaryText.withValues(alpha: .7),
    builder: (context) {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: context.screenHeight * .25),

        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            spacing: spacing,
            children: [
              Container(
                width: 80,
                height: 4,

                margin: .only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              ...children,
            ],
          ),
        ),
      );
    },
  );
}
