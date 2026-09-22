import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
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
                colors: [
                  AppConstColors.secondaryDark,
                  AppConstColors.secondary,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              spacing: 12,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withValues(alpha: .3),

                  child: Text(
                    "Soliman Ali"
                        .trim()
                        .split(RegExp(r'\s+'))
                        .take(2)
                        .map(((e) => e[0]))
                        .join()
                        .toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: .bold,
                      fontSize: 36,
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
          ListTile(
            contentPadding: .symmetric(vertical: 2, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: .circular(20),
              side: BorderSide(color: AppConstColors.orange, width: 1.6),
            ),
            tileColor: AppConstColors.orange.withValues(alpha: .01),
            leading: Icon(
              Remix.car_fill,
              color: AppConstColors.orange,
              size: 30,
            ),
            title: Text(
              "as a driver info",
              style: GoogleFonts.outfit(
                color: AppConstColors.orange,
                fontWeight: .bold,
                fontSize: 16,
              ),
              textAlign: .center,
            ),
            subtitle: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppConstColors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text("Register as a driver"),
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
                    color: AppConstColors.secondaryDark,
                    size: 24,
                  ),

                  title: Text(
                    setting.title,
                    style: GoogleFonts.outfit(
                      color: AppConstColors.primaryBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  subtitle: Text(
                    setting.subtitle,
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                  ),

                  trailing: Icon(
                    Remix.arrow_right_s_line,
                    color: AppConstColors.primaryBlack,
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
            onPressed: () {},
            title: "Sign out",
            icon: Remix.logout_circle_line,
            mainColor: AppConstColors.error,
            isOutlined: true,
          ),

          Text(
            "RideShare v1.0.0",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: .w300,
              fontSize: 10,
            ),
            textAlign: .center,
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
        color: AppConstColors.grey,
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
          style: GoogleFonts.outfit(
            color: primary ? Colors.white : Colors.white.withValues(alpha: .8),
            fontSize: primary ? 16 : 14,
            fontWeight: primary ? .bold : .w300,
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
