import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';
import 'package:ride_share/core/models/setting_tile_model.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/urils/app_date_formatter.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/user_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
    final String userFullName = context.watch<AuthProvider>().getUser!.fullName;
    final String userEmail = context.watch<AuthProvider>().getUser!.email;
    final String userPhone =
        context.watch<AuthProvider>().getUser!.phone ?? 'not found';
    final DateTime userSinceDate = context
        .watch<AuthProvider>()
        .getUser!
        .createdAt;

    final List<ProfileItemModel> profileSettings = [
      ProfileItemModel(
        icon: Remix.user_settings_line,
        title: 'Account Settings',
        subtitle: 'Manage your personal information',
        onTap: () {
          debugPrint('Account Settings tapped');
        },
      ),
      ProfileItemModel(
        icon: Remix.lock_password_line,
        title: 'Privacy & Security',
        subtitle: 'Manage your password and security',
        onTap: () {
          debugPrint('Privacy & Security tapped');
        },
      ),
      ProfileItemModel(
        icon: Remix.notification_3_line,
        title: 'Notifications',
        subtitle: 'Manage your notification preferences',
        onTap: () {
          debugPrint('Notifications tapped');
        },
      ),
      ProfileItemModel(
        icon: Remix.question_line,
        title: 'Help & FAQ',
        subtitle: 'Get help and find answers',
        onTap: () {
          debugPrint('Help & FAQ tapped');
        },
      ),
      ProfileItemModel(
        icon: Remix.information_line,
        title: 'About ride_share',
        subtitle: 'Learn more about the app',
        onTap: () {
          debugPrint('About ride_share tapped');
        },
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        crossAxisAlignment: .center,
        children: [
          // user data (user model)
          Container(
            padding: .all(12),
            height: context.screenHeight * .14,
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppConstColors.shadow,
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
              gradient: LinearGradient(
                colors: [AppConstColors.subSecondary, AppConstColors.secondary],
              ),
            ),
            child: Row(
              mainAxisAlignment: .spaceAround,
              crossAxisAlignment: .center,
              // spacing: 12,
              children: [
                UserAvatar(name: userFullName, fontSize: 30),
                Column(
                  mainAxisAlignment: .spaceEvenly,
                  crossAxisAlignment: .start,
                  children: [
                    ProfileInfoItem(
                      icon: Remix.user_5_fill,
                      text: userFullName,
                    ),
                    ProfileInfoItem(
                      icon: Remix.mail_line,
                      text: userEmail,
                      primary: false,
                    ),
                    ProfileInfoItem(
                      icon: Remix.phone_line,
                      text: userPhone,
                      primary: false,
                    ),
                    ProfileInfoItem(
                      icon: Remix.calendar_event_line,
                      text: DateFormat(DateFormat.YEAR_MONTH_DAY)
                          .format(userSinceDate),
                      primary: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //driver data
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: AppConstColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstColors.subSecondary.withValues(alpha: 0.8),
              ),
              gradient: LinearGradient(
                stops: [.1, .1, .6, .9],
                begin: .topCenter,
                end: .bottomEnd,
                colors: [
                  AppConstColors.subSecondary.withValues(alpha: .1),
                  AppConstColors.primary,
                  AppConstColors.primary,
                  AppConstColors.accent.withValues(alpha: .18),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppConstColors.primary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Remix.car_fill,
                        color: AppConstColors.subSecondary,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Driver',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Start offering rides',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstColors.subSecondary.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Driver',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppConstColors.subSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Description
                Text(
                  'Share your journey with others and earn by offering rides.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade700, height: 1.5),
                ),

                const SizedBox(height: 16),

                // Requirements
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Remix.information_line,
                      color: AppConstColors.subSecondary,
                      size: 19,
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        'You’ll need to provide your personal and vehicle information.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // CTA
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstColors.subSecondary,
                      foregroundColor: AppConstColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Register as a Driver',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Remix.arrow_right_line, size: 19),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //actions
          Container(
            padding: .all(12),
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              color: Colors.transparent,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: profileSettings.length,

              itemBuilder: (context, index) {
                final setting = profileSettings[index];

                return ListTile(
                  contentPadding: .symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: .circular(20)),
                  onTap: setting.onTap,

                  leading: Icon(
                    setting.icon,
                    color: AppConstColors.subSecondary,
                    size: 24,
                  ),

                  title: Text(
                    setting.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  subtitle: Text(
                    setting.subtitle,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),

                  trailing: Icon(
                    Remix.arrow_right_s_line,
                    color: AppConstColors.primaryText,
                  ),
                );
              },

              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          const SizedBox(height: 8),
          //logout
          AppMainButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                showDragHandle: true,
                enableDrag: true,
                builder: (context) {
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: context.screenHeight * .25,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: .center,
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: [
                        Text(
                          "Confirm Sign Out ?",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppConstColors.error),
                        ),
                        Text(
                          "Are you sure you want to sign out of your account?\n- we will clear all your data -",
                          textAlign: .center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                        AppMainButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            if (!context.mounted) return;
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.loginScreen,
                            );
                          },
                          title: "Sign out",
                          icon: Remix.logout_circle_line,
                          mainColor: AppConstColors.error,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            title: "Sign out",
            icon: Remix.logout_circle_line,
            mainColor: AppConstColors.error,
            isOutlined: true,
          ),

          Text(
            "ride_share v1.0.0",
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  const new({
    super.key,
    required this.text,
    required this.icon,
    this.primary = true,
  });
  final String text;
  final IconData icon;
  final bool primary;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(
          icon,
          color: primary ? Colors.white : Colors.white.withValues(alpha: .8),
          size: 16,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: primary ? Colors.white : Colors.white.withValues(alpha: .8),
            fontSize: primary ? 16 : 14,
            fontWeight: primary ? FontWeight.bold : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
