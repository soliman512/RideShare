import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/providers/auth_provider.dart';
import 'package:rider_share/widgets/app_name.dart';

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
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      // Prevent color change when scrolling
      scrolledUnderElevation: 0,

      // Remove Material 3 surface tint
      surfaceTintColor: Colors.transparent,

      // Optional: Keep AppBar transparent
      shadowColor: Colors.transparent,
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
                        ? AppConstColors.orange
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
            color: const Color.fromARGB(61, 255, 153, 0).withValues(alpha: .08),

            // border: Border.symmetric(horizontal: BorderSide(color: AppConstColors.orange, width: 1))
          ),
          padding: const .symmetric(horizontal: 20.0),
          child: Row(
            spacing: 6,
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Become as a",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                width: 160,
                height: 30,
                // padding: .symmetric(vertical: 4, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[10],
                  borderRadius: .circular(40),
                  border: .all(color: AppConstColors.orange, width: 1),
                ),
                child: Stack(
                  alignment: .center,
                  children: [
                    AnimatedAlign(
                      duration: Duration(milliseconds: 100),
                      alignment: isDriver ? .centerRight : .centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: .5,
                        heightFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppConstColors.orange,
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
                          child: Text(
                            "Rider",
                            textAlign: .center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isDriver
                                      ? AppConstColors.orange
                                      : AppConstColors.white,
                                ),
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
                          child: Text(
                            "Driver",
                            textAlign: .center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isDriver
                                      ? AppConstColors.white
                                      : AppConstColors.orange,
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
