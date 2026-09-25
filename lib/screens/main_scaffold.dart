import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/providers/auth_provider.dart';
import 'package:rider_share/providers/current_page_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    int currentPage = context.watch<CurrentPageProvider>().getCurrentPage;
    final userMode = context.watch<AuthProvider>().currentUserMode;

    final List<Widget> pages = [
      userMode == UserMode.rider
          ? const RiderHomeScreen()
          : const DriverHomeScreen(),
      const MyTripsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      appBar: context.watch<CurrentPageProvider>().getCurrentPage == 2
          ? AppBar(toolbarHeight: 40, automaticallyImplyLeading: false)
          : CustomAppBar(isThereNotifications: isThereNotifications),
      body: Padding(padding: const .all(16), child: pages[currentPage]),
      bottomNavigationBar: CircleNavBar(
        activeLevelsStyle: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: Colors.white),

        inactiveLevelsStyle: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: Colors.white),

        onTap: (index) {
          context.read<CurrentPageProvider>().setCurrentPage = index;
          if (index == 1) {
            context.read<AuthProvider>().setMode = UserMode.rider;
          }
        },

        activeIcons: const [
          Icon(Remix.home_6_fill, color: Colors.white),
          Icon(Remix.file_paper_2_fill, color: Colors.white),
          Icon(Remix.account_circle_fill, color: Colors.white),
        ],
        inactiveIcons: [
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Remix.home_6_fill, color: Colors.white, size: 16),
              Text(
                "Home",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Remix.file_paper_2_fill, color: Colors.white, size: 16),
              Text(
                "Trips",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Remix.account_circle_fill, color: Colors.white, size: 16),
              Text(
                "Profile",
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
        color: AppConstColors.secondary,
        circleColor: AppConstColors.secondary,
        height: 60,
        circleWidth: 60,

        // tabCurve: ,
        padding: .zero,
        // cornerRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(0),
        //   topRight: Radius.circular(0),
        //   bottomRight: Radius.circular(0),
        //   bottomLeft: Radius.circular(0),
        // ),
        shadowColor: const Color.fromARGB(255, 191, 197, 204),
        circleShadowColor: const Color.fromARGB(255, 191, 197, 204),
        elevation: 10,
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppConstColors.secondary,
            AppConstColors.secondary,
            AppConstColors.subSecondary,
          ],
        ),
        circleGradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppConstColors.secondary,
            AppConstColors.secondary,
            AppConstColors.subSecondary,
          ],
        ),
        activeIndex: currentPage,
      ),
    );
  }
}
