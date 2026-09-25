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
  static const Color primary = Color(0xfff9fafc);
  static const Color secondary = Color(0xFF003B72);
  static const Color subSecondary = Color(0xFF1687C9);

  static const Color primaryText = Color(0xFF0E0E0E);
  static const Color secondaryText = Color(0xFFA7ADB9);

  static const Color surface = Color(0xFFF1F5FA);
  static const Color white = Color(0xFFFAFCFD);

  static const Color accent = Color(0xFFE9AF3A);
  static const Color shadow = Color(0x12003B72);
  static const Color border = Color(0xFFD9E8EE);

  static const Color error = Color(0xFFE40606);
  static const Color approved = Color(0xFF099340);
}
