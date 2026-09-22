import 'package:flutter/material.dart';

abstract class AppConstImages {
  static const String _path = "assets/images";
  static const String appLogo = "$_path/logo/app_logo.png";
  static const String doodles = "$_path/illustration/rideshare_doodles.png";
  static const String car = "$_path/illustration/car.png";
  static const String welcomeBackground =
      "$_path/illustration/login_background.png";
  static const String riderHomeCenteralShape =
      "$_path/illustration/rider_home_centeral_shape.png";
  static const String noNotificationsYet =
      "$_path/illustration/no_notifications_yet.png";
  static const String splashScreenBackground =
      "$_path/illustration/splash_screen_background.png";

  // ************************ GIFs **************************
  static const String verifyEmailGif = "$_path/illustration/verify_email.gif";
  static const String loading = "$_path/illustration/loading.gif";
}

abstract class AppConstTexts {
  static const String appName = "Ride Share";
}

abstract class AppConstColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(0xFF0E0E0E);
  static const Color secondary = Color(0xFF027EF1);
  static const Color secondaryDark = Color.fromARGB(255, 0, 59, 114);
  static const Color orange = Colors.orange;
  static const Color grey = Color(0xfff1f5fa);
  static const Color error = Color.fromARGB(255, 228, 6, 6);
  static const Color approved = Color(0xFF099340);
}
