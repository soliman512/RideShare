import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/data/mock_database.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/current_page_provider.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/screens/driver/driver_home_screen.dart';
import 'package:ride_share/screens/rider/my_trips_screen.dart';
import 'package:ride_share/screens/rider/rider_home_screen.dart';
import 'package:ride_share/screens/shared/profile_screen.dart';
import 'package:ride_share/core/widgets/custom_app_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  ValueNotifier<bool> isThereNotifications = ValueNotifier<bool>(false);

  @override
  void initState() {
    print("--------------------- users Table ------------------------");
    print(usersTable.length);
    for (var element in usersTable) {
      print(element.id);
      print(element.email);
      print(element.fullName);
      print(element.phone);
      print(element.createdAt);
      print(element.currentMode);
      print("${AppStorageKeys.canBecomeDriver} : false");
      print("===================");
    }
    print("--------------------- end  ------------------------");
    super.initState();
  }

  String userFullName = 'Unkoun';

  @override
  Widget build(BuildContext context) {
    final authProviderWatch = context.watch<AuthProvider>();
    int currentPage = context.watch<CurrentPageProvider>().getCurrentPage;
    final userMode = authProviderWatch.currentUserMode;
    final user = authProviderWatch.getUser;
    if (user == null) {
      context.watch<LoadingProvider>().show();
    } else {
      context.watch<LoadingProvider>().hide();
      userFullName = user.fullName.split(' ').take(1).join();
    }

    final List<Widget> pages = [
      userMode == UserMode.rider
          ? RiderHomeScreen(fullName: userFullName)
          : const DriverHomeScreen(),
      const MyTripsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: context.watch<CurrentPageProvider>().getCurrentPage == 2
          ? AppBar(
              toolbarHeight: 20,
              automaticallyImplyLeading: false,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            )
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
