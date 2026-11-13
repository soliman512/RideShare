import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstColors.shadow.withValues(alpha: 0.28),
      body: Center(
        child: Container(
          clipBehavior: .antiAlias,
          width: context.screenWidth * .25.w,
          height: context.screenWidth * .25.w,
          // margin: .symmetric(horizontal: context.screenWidth * .3),

          padding: const .all(0),
          decoration: BoxDecoration(
            color: AppConstColors.surface,
            borderRadius: BorderRadius.circular(20.r),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 60,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            width: 100.w,
            height: 100.w,
            child: Image.asset(AppConstImages.loading, fit: .contain),
          ),
        ),
      ),
    );
  }
}
