import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/services/auth_services.dart';
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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: .3,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
    Timer(Duration(milliseconds: 2000), () {
      if (AuthServices.isUserHasSession()) {
        context.read<AuthProvider>().loadUser();
        Navigator.pushReplacementNamed(context, AppRoutes.mainScaffold);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: .center,
        children: [
          Image.asset(
            AppConstImages.splashScreenBackground,
            width: double.infinity,
            height: double.infinity,
            fit: .cover,
          ),
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(scale: _animation.value, child: child);
                },
                child: Image.asset(AppConstImages.appLogo, width: 80),
              ),
              const SizedBox(height: 12),
              AppName(),
              Text(
                "Better Rides . Together.",
                textAlign: .center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: .w200,
                ),
              ),
              const SizedBox(height: 4),

              SizedBox(
                width: context.screenWidth * .4,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  borderRadius: .circular(20),
                  // color: Theme.of(context).,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              // LinearProgressIndicator(
              //   minHeight: 12,
              //   borderRadius: .circular(20),
              //   // color: Theme.of(context).,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              // SizedBox(height: 120),
            ],
          ),
        ],
      ),
    );
  }
}
