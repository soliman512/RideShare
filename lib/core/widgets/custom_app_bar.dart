import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/current_page_provider.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_name.dart';

import 'show_app_modal_sheet.dart';

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
    bool isDriver =
        context.watch<AuthProvider>().currentUserMode == UserMode.driver;
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
                        children: [
                          //rider tab
                          Expanded(
                            child: GestureDetector(
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
                                        ? AppConstColors.primaryText
                                        : Colors.white,
                                    size: 10,
                                  ),
                                  Text(
                                    "Rider",
                                    textAlign: .center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: isDriver
                                              ? AppConstColors.primaryText
                                              : Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // driver tab
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isDriver == false) {
                                  if (context
                                          .read<AuthProvider>()
                                          .canBecomeDriver ==
                                      true) {
                                    context.read<AuthProvider>().setMode =
                                        UserMode.driver;
                                  } else {
                                    //show info modal to become as a driver
                                    showAppModalSheet(
                                      context,
                                      spacing: 12,
                                      children: [
                                        // Header
                                        const SizedBox(width: 14),
                                        Text(
                                          'Become a Driver',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    AppConstColors.primaryText,
                                              ),
                                        ),
                                        Text(
                                          'Start offering rides and earn with your vehicle.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: AppConstColors
                                                    .secondaryText,
                                              ),
                                        ),

                                        // Steps
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              _StepItem(
                                                icon: Remix.user_3_fill,
                                                label: 'Profile',
                                                isActive: false,
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Divider(
                                                    thickness: 1.2,
                                                    color:
                                                        AppConstColors.border,
                                                  ),
                                                ),
                                              ),

                                              _StepItem(
                                                icon: Remix.car_fill,
                                                label: 'Driver Registration',
                                                isActive: true,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Information
                                        Padding(
                                          padding: const .symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            'Complete your driver registration from your profile to unlock driver features.',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  height: 1.5,
                                                  color: AppConstColors
                                                      .secondaryText,
                                                ),
                                          ),
                                        ),

                                        AppMainButton(
                                          title: 'to profile',
                                          icon: Remix.arrow_right_line,
                                          mainColor: AppConstColors.accent,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context
                                                    .read<CurrentPageProvider>()
                                                    .setCurrentPage =
                                                2;
                                          },
                                        ),
                                      ],
                                    );
                                  }

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

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppConstColors.accent : AppConstColors.primaryText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
