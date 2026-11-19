import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/extension/driver_approval_status_extension.dart';
import 'package:ride_share/core/providers/app_info_provider.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/driver_profile_provider.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';
import 'package:ride_share/core/supabase_services/driver_profile_services.dart';
import 'package:ride_share/core/widgets/app_name.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ValueNotifier<bool> showLoadYourData = ValueNotifier<bool>(false);
  ValueNotifier<bool> showLoadYourDriverProfileData = ValueNotifier<bool>(
    false,
  );

  Future<void> getAppInfo() async {
    await context.read<AppInfoProvider>().initAppInfo();
  }

  @override
  void initState() {
    getAppInfo();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: .3,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    ///////////////////////////////
    Timer(Duration(milliseconds: 2000), () async {
      showLoadYourData.value = true;
      if (AuthServices.isUserHasSession()) {
        await context.read<AuthProvider>().loadUser();
        if (await AuthServices.isUserProfileExists() == false) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.profileSetupScreen);
        } else {
          if (await DriverProfileServices.isUserHasDriverProfile()) {
            showLoadYourDriverProfileData.value = true;
            showLoadYourData.value = false;
            if (!mounted) return;
            final driver = await DriverProfileServices.loadDriverProfileData();
            if (driver == null) return;
            if (!mounted) return;

            context.read<DriverProfileProvider>().setDriverProfile = driver;
            // context.read<DriverProfileProvider>().setCanBecomeDriver =
            //     driver.approvalStatus == DriverApprovalStatus.approved;
          }
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.mainScaffold);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.asset(
                AppConstImages.splashScreenBackground,
                fit: BoxFit.cover,
              ),

              // Soft overlay
              Container(color: Colors.white.withValues(alpha: 0.08)),

              // Top-left logo
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Transform.scale(
                        scale: _animation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    AppConstImages.appLogo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Centered app name

              // Tagline and loading indicator
              Column(
                mainAxisAlignment: .center,
                children: [
                  AppName(fontSize: 40),
                  Text(
                    'Better Rides. Together.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppConstColors.secondaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: primaryColor,
                      backgroundColor: primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),

              // Bottom footer
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  spacing: 4,
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .end,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: showLoadYourData,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value,
                          child: Text(
                            'load your data...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: showLoadYourDriverProfileData,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value,
                          child: Text(
                            'load your as a driver data...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
