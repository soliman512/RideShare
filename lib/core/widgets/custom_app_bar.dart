import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/core/constants/app_constants.dart';
import 'package:rider_share/core/constants/app_routes.dart';
import 'package:rider_share/core/providers/auth_provider.dart';
import 'package:rider_share/core/providers/current_page_provider.dart';
import 'package:rider_share/core/widgets/app_name.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const new({super.key, required this.isThereNotifications});
  final ValueNotifier<bool> isThereNotifications;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider mode = context.watch<AuthProvider>();
    bool isDriver = mode.currentUserMode == UserMode.driver;
    bool hideSwitcher =
        context.watch<CurrentPageProvider>().getCurrentPage == 1;
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      foregroundColor: AppConstColors.secondary,
      // leading: Image.asset(AppConstImages.appLogo, width: 6),
      automaticallyImplyLeading: false,
      title: Row(
        // spacing: 12,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Image.asset(AppConstImages.appLogo, width: 22),
          AppName(fontSize: 22, removeR: true),
        ],
      ),
      actions: [
        // Stack(
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         color: Colors.grey[300],
        //         borderRadius: .circular(30),
        //       ),
        //       child: Row(
        //         mainAxisAlignment: .spaceAround,
        //         children: [
        //           Text("rider")
        //           ,Text("driver")
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        // FilledButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.grey[50],
        //     foregroundColor: AppConstColors.orange,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: .circular(30),
        //       side: BorderSide(color: AppConstColors.orange),
        //     ),
        //     padding: .zero,
        //   ),
        //   child: Text("as Driver"),
        // ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notificationsScreen);
          },
          icon: Stack(
            alignment: .topRight,
            children: [
              ValueListenableBuilder(
                valueListenable: widget.isThereNotifications,
                builder: (context, value, child) {
                  return Icon(
                    value
                        ? Remix.notification_3_fill
                        : Remix.notification_3_line,
                    color: value
                        ? AppConstColors.accent
                        : AppConstColors.secondary,
                  );
                },
              ),
              // CircleAvatar(
              //   backgroundColor: AppConstColors.amberGold,
              //   radius: 6,
              // ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: .only(
          bottomLeft: .circular(20),
          bottomRight: .circular(20),
        ),
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          decoration: BoxDecoration(
            color: AppConstColors.subSecondary.withValues(alpha: .06),
          ),
          padding: const .symmetric(horizontal: 20.0),
          child: Row(
            spacing: 6,
            crossAxisAlignment: .center,
            mainAxisAlignment: hideSwitcher ? .center : .spaceBetween,
            children: [
              Text(
                hideSwitcher
                    ? "Trips are for Rider Mode only."
                    : "Become as a ..",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (hideSwitcher) const SizedBox(height: 30),
              if (!hideSwitcher)
                Container(
                  width: 140,
                  height: 28,
                  // padding: .symmetric(vertical: 4, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[10],
                    borderRadius: .circular(40),
                    border: .all(color: AppConstColors.secondary, width: 1),
                  ),
                  child: Stack(
                    alignment: .center,
                    children: [
                      AnimatedAlign(
                        duration: Duration(milliseconds: 360),
                        curve: Curves.easeInBack,
                        alignment: isDriver ? .centerRight : .centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: .5,
                          heightFactor: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppConstColors.secondary,
                              borderRadius: .circular(40),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: .spaceAround,
                        crossAxisAlignment: .center,
                        // spacing: 40,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isDriver == true) {
                                context.read<AuthProvider>().setMode =
                                    UserMode.rider;
                                // setState(() {
                                //   isDriver = false;
                                // });
                              }
                            },
                            child: Row(
                              spacing: 4,
                              crossAxisAlignment: .center,
                              mainAxisSize: .min,
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  Remix.user_fill,
                                  color: isDriver
                                      ? AppConstColors.secondary
                                      : Colors.white,
                                  size: 10,
                                ),
                                Text(
                                  "Rider",
                                  textAlign: .center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDriver
                                            ? AppConstColors.secondary
                                            : Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isDriver == false) {
                                context.read<AuthProvider>().setMode =
                                    UserMode.driver;

                                // setState(() {
                                //   isDriver = true;
                                // });
                              }
                            },
                            child: Row(
                              spacing: 4,
                              mainAxisSize: .min,
                              crossAxisAlignment: .center,
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  Remix.car_fill,
                                  color: isDriver
                                      ? Colors.white
                                      : AppConstColors.secondary,
                                  size: 10,
                                ),
                                Text(
                                  "Driver",
                                  textAlign: .center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDriver
                                            ? Colors.white
                                            : AppConstColors.secondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
