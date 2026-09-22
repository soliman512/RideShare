import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/providers/auth_provider.dart';
import 'package:rider_share/screens/driver/driver_home_screen.dart';
import 'package:rider_share/screens/rider/my_trips_screen.dart';
import 'package:rider_share/screens/rider/rider_home_screen.dart';
import 'package:rider_share/screens/shared/profile_screen.dart';
import 'package:rider_share/widgets/custom_app_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  ValueNotifier<bool> isThereNotifications = ValueNotifier<bool>(false);
  final riderHome = const RiderHomeScreen();
  final driverHome = const DriverHomeScreen();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      context.watch<AuthProvider>().currentUserMode == UserMode.rider
          ? const RiderHomeScreen()
          : const DriverHomeScreen(),
      const MyTripsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      appBar: CustomAppBar(isThereNotifications: isThereNotifications),
      body: Padding(padding: const .all(20), child: pages[currentPage]),
      bottomNavigationBar: CircleNavBar(
        activeLevelsStyle: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: AppConstColors.white),

        inactiveLevelsStyle: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: AppConstColors.white),
        onTap: (index) {
          currentPage = index;
          setState(() {});
        },

        activeIcons: const [
          Icon(Remix.home_6_fill, color: AppConstColors.white),
          Icon(Remix.file_paper_2_fill, color: AppConstColors.white),
          Icon(Remix.account_circle_fill, color: AppConstColors.white),
        ],
        inactiveIcons: [
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Remix.home_6_fill, color: AppConstColors.white, size: 16),
              Text(
                "Home",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppConstColors.white),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(
                Remix.file_paper_2_fill,
                color: AppConstColors.white,
                size: 16,
              ),
              Text(
                "Trips",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppConstColors.white),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(
                Remix.account_circle_fill,
                color: AppConstColors.white,
                size: 16,
              ),
              Text(
                "Profile",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppConstColors.white),
              ),
            ],
          ),
        ],
        color: Colors.white,
        circleColor: Colors.white,
        height: 60,
        circleWidth: 60,

        // tabCurve: ,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: AppConstColors.secondaryDark,
        circleShadowColor: AppConstColors.secondaryDark,
        elevation: 10,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppConstColors.secondary, AppConstColors.secondaryDark],
        ),
        circleGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppConstColors.secondary, AppConstColors.secondaryDark],
        ),
        activeIndex: currentPage,
      ),
    );
  }
}
