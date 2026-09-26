import 'package:flutter/material.dart';
import 'package:rider_share/core/constants/app_constants.dart';

class CustomDivider extends StatelessWidget {
  const new({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: Divider(
            color: AppConstColors.secondaryText,
            thickness: 1,
            height: 1,
            radius: .circular(12),
          ),
        ),
        Text(
          title.toLowerCase(),
          style: Theme.of(context).textTheme.labelMedium!
              .copyWith(color: AppConstColors.secondaryText),
        ),
        Expanded(
          child: Divider(
            color: AppConstColors.secondaryText,
            thickness: 1,
            height: 1,
            radius: .circular(12),
          ),
        ),
      ],
    );
  }
}
