import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/providers/auth_provider.dart';
import 'package:rider_share/providers/loading_provider.dart';
import 'package:rider_share/screens/auth/login_screen.dart';
import 'package:rider_share/screens/auth/profile_setup_screen.dart';
import 'package:rider_share/screens/auth/verify_otp_screen.dart';
import 'package:rider_share/screens/driver/create_ride_screen.dart';
import 'package:rider_share/screens/main_scaffold.dart';
import 'package:rider_share/screens/rider/ride_details_screen.dart';
import 'package:rider_share/screens/shared/notifications_screen.dart';
import 'package:rider_share/screens/splash/splash_screen.dart';
import 'package:rider_share/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:rider_share/widgets/default_body.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LoadingProvider()),
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
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RideShare',
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
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstColors.white.withValues(alpha: .9),
      body: const Center(
        child: DefaultBody(
          imageOpacity: 1,
          imagePath: AppConstImages.loading,
          title: 'Loading...',
          subtitle: 'Please wait a moment.',
        ),
      ),
    );
  }
}
