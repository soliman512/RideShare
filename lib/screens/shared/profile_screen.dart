import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/extension/app_extensions.dart';
import 'package:rider_share/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
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
        title: 'About RideShare',
        subtitle: 'Learn more about the app',
        onTap: () {
          debugPrint('About RideShare tapped');
        },
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        crossAxisAlignment: .center,
        children: [
          Container(
            padding: .all(12),
            height: context.screenHeight * .14,
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              gradient: LinearGradient(
                colors: [AppConstColors.subSecondary, AppConstColors.secondary],
              ),
            ),
            child: Row(
              mainAxisAlignment: .spaceAround,
              crossAxisAlignment: .center,
              // spacing: 12,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withValues(alpha: .3),

                  child: Text(
                    "Soliman Ali"
                        .trim()
                        .split(RegExp(r'\s+'))
                        .take(2)
                        .map(((e) => e[0]))
                        .join()
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: .spaceEvenly,
                  crossAxisAlignment: .start,
                  children: [
                    ProfileInfoItem(
                      icon: Remix.user_5_fill,
                      text: "Soliman Ali",
                    ),
                    ProfileInfoItem(
                      icon: Remix.mail_fill,
                      text: "soliman512ali@gmail.com",
                      primary: false,
                    ),
                    ProfileInfoItem(
                      icon: Remix.phone_fill,
                      text: "01065765512",
                      primary: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstColors.accent.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstColors.accent.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Remix.car_fill,
                        color: AppConstColors.accent,
                        size: 28,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstColors.accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Driver",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppConstColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  "Become a Driver",
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                // Description
                Text(
                  "Want to offer rides and share your journey with others?",
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade600, height: 1.5),
                ),

                const SizedBox(height: 16),

                // Registration info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstColors.accent.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Remix.information_fill,
                        color: AppConstColors.accent,
                        size: 20,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "You need to register and provide your personal "
                          "and vehicle information before becoming a driver.",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Remix.arrow_right_line),
                    label: const Text("Register as a Driver"),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Section(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: profileSettings.length,

              itemBuilder: (context, index) {
                final setting = profileSettings[index];

                return ListTile(
                  contentPadding: .symmetric(horizontal: 8),

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
                          "Are you sure you want to sign out of your account?",

                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                        AppMainButton(
                          onPressed: () {
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
            "RideShare v1.0.0",
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

class Section extends StatelessWidget {
  const new({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: AppConstColors.surface,
      ),
      child: child,
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

class ProfileItemModel {
  const ProfileItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
