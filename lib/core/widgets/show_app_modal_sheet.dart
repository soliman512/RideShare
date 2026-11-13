import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';


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
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppConstColors.surface,
    barrierColor: AppConstColors.primaryText.withValues(alpha: .7),
    builder: (context) {
      final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: keyboardHeight,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .9,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                ..._addSpacing(
                  children,
                  spacing,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

List<Widget> _addSpacing(
  List<Widget> children,
  double spacing,
) {
  return [
    for (int i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(height: spacing),
      children[i],
    ],
  ];
}