import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/current_page_provider.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/screens/auth/login_screen.dart';
import 'package:ride_share/screens/auth/profile_setup_screen.dart';
import 'package:ride_share/screens/auth/verify_otp_screen.dart';
import 'package:ride_share/screens/driver/create_ride_screen.dart';
import 'package:ride_share/screens/main_scaffold.dart';
import 'package:ride_share/screens/rider/ride_details_screen.dart';
import 'package:ride_share/screens/shared/notifications_screen.dart';
import 'package:ride_share/screens/splash/splash_screen.dart';
import 'package:ride_share/core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/shared/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize the Supabase 
    await Supabase.initialize(
    url: 'https://uuumrjmucqmeeellbfuz.supabase.co',
    publishableKey: 'sb_publishable_0zn36MXKIwHk4Y7dU9vwhw_9XThcG5n',
  );
  //initialize providers & make app orientation always in portrait up (first)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LoadingProvider()),
          ChangeNotifierProvider(create: (_) => CurrentPageProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360.0, 825.5),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (_, child) => SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ride_share',
          theme: AppTheme.theme,
          builder: (context, child) {
            return Consumer<LoadingProvider>(
              builder: (context, loadingProvider, appChild) {
                return Stack(
                  children: [
                    child ?? const SizedBox.shrink(),

                    if (loadingProvider.isLoading) LoadingScreen(),
                  ],
                );
              },
            );
          },
          initialRoute: AppRoutes.splashScreen,
          routes: {
            AppRoutes.splashScreen: (context) => SplashScreen(),
            AppRoutes.loginScreen: (context) => LoginScreen(),
            AppRoutes.verifyOtpScreen: (context) => VerifyOtpScreen(),
            AppRoutes.profileSetupScreen: (context) => ProfileSetupScreen(),
            AppRoutes.rideDetailsScreen: (context) => RideDetailsScreen(),
            AppRoutes.createRideScreen: (context) => CreateRideScreen(),
            AppRoutes.mainScaffold: (context) => MainScaffold(),
            AppRoutes.notificationsScreen: (context) => NotificationsScreen(),
          },
        ),
      ),
    );
  }
}
