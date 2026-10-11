import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/data/mock_database.dart';
import 'package:ride_share/core/models/setting_tile_model.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/user_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ride_share/core/widgets/show_app_modal_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<FormState> driverFormKey = GlobalKey<FormState>();
  final TextEditingController idCardUrlController = TextEditingController();
  final TextEditingController criminalRecordUrlController =
      TextEditingController();
  String? appName;

  String? appVersion;
  bool messages = true;
  bool rideRequests = true;

  bool showBecomeDriverForm = false;
  late TextEditingController userNewFullNameController;
  late TextEditingController userNewPhoneNumberContoller;

  final ImagePicker imagePicker = ImagePicker();
  XFile? idCard;
  XFile? criminalRecord;

  Future<void> saveUserNewData() async {
    final loadingProvider = context.read<LoadingProvider>();
    final authProvider = context.read<AuthProvider>();

    loadingProvider.show();

    try {
      final userId = authProvider.getUser!.id;

      for (final user in usersTable) {
        if (user.id != userId) continue;
        //will work one time
        final newFullName = userNewFullNameController.text.trim();
        final newPhoneNumber = userNewPhoneNumberContoller.text.trim();

        if (newFullName.isNotEmpty) {
          user.fullName = newFullName;
          authProvider.setUserFullName = newFullName;
        }

        if (newPhoneNumber.isNotEmpty) {
          user.phone = newPhoneNumber;
          authProvider.setUserPhoneNumber = newPhoneNumber;
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your profile has been updated successfully.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppConstColors.white),
            ),
            backgroundColor: AppConstColors.approved,
          ),
        );

        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('there is problem, try again later.')),
      );
    } catch (e) {
      debugPrint('Failed to update profile: $e');
    } finally {
      userNewFullNameController.clear();
      userNewPhoneNumberContoller.clear();
      loadingProvider.hide();
    }
  }

  Future<void> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    });
  }

  void submitDriverApplication() {}

  @override
  void initState() {
    super.initState();
    userNewFullNameController = TextEditingController();
    userNewPhoneNumberContoller = TextEditingController();
  }

  @override
  void dispose() {
    userNewFullNameController.dispose();
    userNewPhoneNumberContoller.dispose();
    idCardUrlController.dispose();
    criminalRecordUrlController.dispose();
    super.dispose();
  }

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
    bool canBecomeDriver =
        context.read<AuthProvider>().canBecomeDriver ?? false;

    //actions items
    final List<ProfileItemModel> profileSettings = [
      // Account Settings
      // ─────────────────────────────────────────────
      ProfileItemModel(
        icon: Remix.user_settings_line,
        title: 'Account Settings',
        subtitle: 'Manage your personal information',
        onTap: () {
          showAppModalSheet(
            context,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Account Settings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit profile',
                    onPressed: () {
                      Navigator.pop(context);
                      showAppModalSheet(
                        context,
                        children: [
                          Text(
                            'Edit Profile',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Update your personal information.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 16),
                          Form(
                            key: formState,
                            child: Column(
                              spacing: 12,
                              children: [
                                AppTextFormField(
                                  controller: userNewFullNameController,
                                  inputAction: .done,
                                  hintText: userFullName,
                                  labelText: 'new full name',
                                  prefixIcon: Icon(Remix.user_line),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'ⓘ Full name is required';
                                    }

                                    return null;
                                  },
                                ),

                                AppTextFormField(
                                  controller: userNewPhoneNumberContoller,
                                  keyboardType: TextInputType.phone,
                                  inputAction: .done,
                                  maxLength: 11,
                                  hintText: userPhone,
                                  labelText: 'new phone number',
                                  prefixIcon: Icon(Remix.phone_line),
                                  validator: (value) {
                                    final phone = value?.trim() ?? '';

                                    if (phone.isEmpty) {
                                      return null;
                                    }

                                    if (!phone.startsWith('010') &&
                                        !phone.startsWith('011') &&
                                        !phone.startsWith('012') &&
                                        !phone.startsWith('015')) {
                                      return 'ⓘ Please enter a valid phone number';
                                    }

                                    if (phone.length != 11) {
                                      return 'ⓘ Please enter a valid phone number';
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: AppMainButton(
                              onPressed: () {
                                if (formState.currentState!.validate()) {
                                  if (userNewFullNameController
                                          .text
                                          .isNotEmpty ||
                                      userNewPhoneNumberContoller
                                          .text
                                          .isNotEmpty) {
                                    saveUserNewData();
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              title: 'Save Changes',
                              icon: Remix.save_line,
                            ),
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Remix.edit_line),
                  ),
                ],
              ),

              Text(
                'Update your personal information and account details.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.user_line),
                title: const Text('Full Name'),
                subtitle: Text(userFullName),
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.mail_line),
                title: const Text('Email'),
                subtitle: Text(userEmail),
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.phone_line),
                title: const Text('Phone Number'),
                subtitle: Text(userPhone.isEmpty ? 'Not added' : userPhone),
              ),
            ],
          );
        },
      ),

      // Notifications
      // ─────────────────────────────────────────────
      ProfileItemModel(
        icon: Remix.notification_3_line,
        title: 'Notifications',
        subtitle: 'Manage your notification preferences',
        onTap: () {
          showAppModalSheet(
            context,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                'Choose which notifications you want to receive.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SwitchListTile.adaptive(
                  //   contentPadding: EdgeInsets.zero,
                  //   secondary: const Icon(Remix.route_line),
                  //   title: const Text('Trip Updates'),
                  //   subtitle: const Text('Receive updates about your trips'),
                  //   value: tripUpdates,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       tripUpdates = value;
                  //     });

                  //     // Save notification preference
                  //   },
                  // ),
                  SwitchListTile.adaptive(
                    activeThumbColor: AppConstColors.subSecondary,
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Remix.message_2_line),
                    title: const Text('Messages'),
                    subtitle: const Text(
                      'Receive notifications for new messages',
                    ),
                    value: messages,
                    onChanged: (value) {
                      setState(() {
                        messages = value;
                      });

                      // Save notification preference
                    },
                  ),
                  if (canBecomeDriver)
                    SwitchListTile.adaptive(
                      activeThumbColor: AppConstColors.subSecondary,
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Remix.car_line),
                      title: const Text('Ride Requests'),
                      subtitle: const Text(
                        'Receive notifications for ride requests',
                      ),
                      value: rideRequests,
                      onChanged: (value) {
                        setState(() {
                          rideRequests = value;
                        });

                        // Save notification preference
                      },
                    ),
                ],
              ),
            ],
          );
        },
      ),

      // Help & FAQ
      // ─────────────────────────────────────────────
      ProfileItemModel(
        icon: Remix.question_line,
        title: 'Help & FAQ',
        subtitle: 'Get help and find answers',
        onTap: () async {
          showAppModalSheet(
            context,
            children: [
              Text(
                'Help & FAQ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                'Find answers to common questions about RideShare.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              HelpExpansionTile(
                icon: Remix.search_line,
                title: 'How do I book a ride?',
                text:
                    'Search for your destination from the home screen, '
                    'choose an available ride, and follow the booking steps.',
              ),

              HelpExpansionTile(
                icon: Remix.car_line,
                title: 'How do I become a driver?',
                text:
                    'Open your profile and select the Become a Driver '
                    'option. Follow the registration steps to submit '
                    'your driver information.',
              ),

              HelpExpansionTile(
                icon: Remix.close_circle_line,
                title: 'How can I cancel a ride?',
                text:
                    'Open your trip details and use the cancellation '
                    'option if the trip is still eligible for cancellation.',
              ),
            ],
          );
        },
      ),

      // About
      // ─────────────────────────────────────────────
      ///TODO: make this secion work
      ProfileItemModel(
        icon: Remix.information_line,
        title: 'About RideShare',
        subtitle: 'Learn more about the app',
        onTap: () {
          getAppInfo();

          showAppModalSheet(
            context,
            children: [
              Text(
                'About RideShare',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                'A simple platform for connecting riders and drivers.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.information_line),
                title: const Text('App Version'),
                subtitle: Text('$appName v$appVersion'),
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.shield_check_line),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Remix.arrow_right_s_line),
                onTap: () {
                  // Open privacy policy
                },
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.file_text_line),
                title: const Text('Terms of Service'),
                trailing: const Icon(Remix.arrow_right_s_line),
                onTap: () {
                  // Open terms
                },
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Remix.github_line),
                title: const Text('About the Project'),
              ),
            ],
          );
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppConstColors.subSecondary, AppConstColors.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstColors.shadow,
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              spacing: 8,
              children: [
                // Avatar + Name + email
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UserAvatar(name: userFullName, fontSize: 24),
                  title: Text(
                    userFullName.isNotEmpty ? userFullName : 'Not added',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppConstColors.white,
                    ),
                  ),
                  subtitle: Text(
                    userEmail.isNotEmpty ? userEmail : 'Not added',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstColors.accent,
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // phone number + roles
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ProfileInfoItem(
                        icon: Remix.phone_fill,
                        text: userPhone.isNotEmpty ? userPhone : 'Not added',
                      ),
                    ),

                    Expanded(
                      child: ProfileInfoItem(
                        icon: canBecomeDriver
                            ? Remix.car_fill
                            : Remix.user_fill,
                        text: 'Rider ${canBecomeDriver ? '| Driver' : ''}',
                      ),
                    ),
                  ],
                ),
                // account created at
                ProfileInfoItem(
                  icon: Remix.calendar_event_fill,
                  text: DateFormat(DateFormat.YEAR_MONTH_DAY)
                      .format(userSinceDate),
                ),
              ],
            ),
          ), //driver data
          AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
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
                ListTile(
                  contentPadding: .zero,
                  leading: Container(
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
                  title: Text(
                    'Become a Driver',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Start offering rides',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),

                // Description
                Text(
                  'Share your journey with others and earn by offering rides.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade700, height: 1.5),
                ),

                const SizedBox(height: 16),

                // Requirements
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: showBecomeDriverForm
                      ? Form(
                          key: driverFormKey,
                          child: Column(
                            spacing: 14,
                            children: [
                              Row(
                                spacing: 12,
                                children: [
                                  //id card front face
                                  Expanded(
                                    child: UploadSection(
                                      icon: Remix.id_card_fill,
                                      title: 'ID card\n(front face)',
                                      image: idCard != null
                                          ? Image.file(
                                              File(idCard!.path),
                                              fit: .cover,
                                            )
                                          : null,

                                      onTap: () async {
                                        context.read<LoadingProvider>().show();
                                        idCard = await imagePicker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (!mounted) return;
                                        context.read<LoadingProvider>().hide();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  //criminal record
                                  Expanded(
                                    child: UploadSection(
                                      icon: Remix.file_paper_fill,
                                      title: 'criminal\nrecord',
                                      image: criminalRecord != null
                                          ? Image.file(
                                              File(criminalRecord!.path),
                                              fit: .cover,
                                            )
                                          : null,
                                      onTap: () async {
                                        context.read<LoadingProvider>().show();

                                        criminalRecord = await imagePicker
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        if (!mounted) return;
                                        context.read<LoadingProvider>().hide();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 12,
                                children: [
                                  IconButton(
                                    tooltip: 'Back',
                                    onPressed: () {
                                      criminalRecord = null;
                                      idCard = null;
                                      setState(() {
                                        showBecomeDriverForm = false;
                                      });
                                    },
                                    icon: const Icon(Remix.arrow_left_line),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: AppMainButton(
                                      onPressed: submitDriverApplication,
                                      title: 'Submit',
                                      mainColor: AppConstColors.accent,

                                      icon: Remix.send_plane_line,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Row(
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 18),

                if (!showBecomeDriverForm)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          showBecomeDriverForm = true;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstColors.accent,
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
            onPressed: () => showAppModalSheet(
              context,
              children: [
                Text(
                  'Confirm Sign Out?',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: AppConstColors.error),
                ),
                Text(
                  'Are you sure you want to sign out of your account?\n'
                  '- we will clear all your data -',
                  textAlign: .center,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: Colors.grey),
                ),
                AppMainButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    if (!context.mounted) return;

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.loginScreen,
                    );
                  },
                  title: 'Sign out',
                  icon: Remix.logout_circle_line,
                  mainColor: AppConstColors.error,
                ),
              ],
            ),
            title: "Sign out",
            icon: Remix.logout_circle_line,
            mainColor: AppConstColors.error,
            isOutlined: true,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class HelpExpansionTile extends StatelessWidget {
  const new({
    super.key,
    required this.icon,
    required this.text,
    required this.title,
  });
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      iconColor: AppConstColors.subSecondary,
      textColor: AppConstColors.subSecondary,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Text(text, style: TextTheme.of(context).labelMedium),
        ),
      ],
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  const new({super.key, required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(4),
      alignment: .center,
      decoration: BoxDecoration(
        color: AppConstColors.white.withValues(alpha: .2),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Icon(icon, color: AppConstColors.accent, size: 16),
          Flexible(
            child: Text(
              text,
              textAlign: .center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppConstColors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadSection extends StatelessWidget {
  const UploadSection({
    required this.icon,
    required this.title,
    required this.onTap,
    this.image,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxHeight: 120, minHeight: 120),
        clipBehavior: .antiAlias,
        padding: image != null ? .zero : const .all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppConstColors.white.withValues(alpha: .3),
          border: .all(color: AppConstColors.secondary, width: .3),
        ),
        child:
            image ??
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              mainAxisAlignment: .center,
              children: [
                Icon(icon, size: 28, color: AppConstColors.secondary),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
      ),
    );
  }
}
