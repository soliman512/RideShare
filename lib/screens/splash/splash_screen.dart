import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/widgets/app_name.dart';

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
    Timer(Duration(milliseconds: 1400), () {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
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
              AppName(),
              Text(
                "Better Rides . Together.",
                textAlign: .center,
                style: GoogleFonts.outfit(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: .w200,
                ),
              ),
              SizedBox(height: 120),
            ],
          ),
        ],
      ),
    );
  }
}
