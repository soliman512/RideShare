import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/core/extension/driver_approval_status_extension.dart';
import 'package:ride_share/core/providers/driver_profile_provider.dart';
import 'package:ride_share/core/services/driver_storage_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/user_avatar.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/widgets/custom_divider.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/models/setting_tile_model.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/core/providers/app_info_provider.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/show_app_modal_sheet.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';
import 'package:ride_share/core/supabase_services/driver_profile_services.dart';
import 'package:ride_share/core/extension/english_nums_to_arabic_extension.dart';

class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _driverBoxAnimationController;

  //forms key
  GlobalKey<FormState> newUserDataFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> driverFormState = GlobalKey<FormState>();

  //driver form fields
  final TextEditingController driverCarType = TextEditingController();
  final TextEditingController driverCarModel = TextEditingController();
  final TextEditingController driverCarLicensePlateLetters =
      TextEditingController();
  final TextEditingController driverCarLicensePlateNumbers =
      TextEditingController();
  final TextEditingController driverCarColor = TextEditingController();
  // attachments
  final ImagePicker imagePicker = ImagePicker();
  XFile? idCard;
  XFile? criminalRecord;
  XFile? drivingLicense;
  List<XFile> carImages = [];
  //stats
  bool messages = true;
  bool rideRequests = true;
  bool showBecomeDriverForm = false;

  // update data fields
  TextEditingController newUserFullNameController = TextEditingController();
  TextEditingController newUserPhoneNumberContoller = TextEditingController();
  XFile? newUserProfilePicture;

  //app info
  String? appName;
  String? appVersion;

  // update user data in supabase

  Future<void> saveUserNewData() async {
    final loadingProvider = context.read<LoadingProvider>();
    final authProvider = context.read<AuthProvider>();

    loadingProvider.show();

    try {
      final user = authProvider.user!;

      String? profilePictureUrl;

      // 1. Handle profile picture update.
      if (newUserProfilePicture != null) {
        final oldImageUrl = user.profilePictureUrl;

        if (oldImageUrl == null) {
          profilePictureUrl = await AuthServices.uploadProfilePicture(
            userId: user.id,
            imagePath: newUserProfilePicture!.path,
          );
        } else {
          profilePictureUrl = await AuthServices.updateUserProfilePicture(
            userId: user.id,
            newImage: newUserProfilePicture!,
            oldImageUrl: oldImageUrl,
          );
        }
      }

      // 2. Update user information.
      await AuthServices.updateUserData(
        userId: user.id,
        fullName: newUserFullNameController.text.trim(),
        phone: newUserPhoneNumberContoller.text.trim(),
        profilePictureUrl: profilePictureUrl,
      );
      // 3. Reload updated user data.
      await authProvider.loadUser();

      newUserProfilePicture = null;

      if (!mounted) return;

      CherryToast.success(
        inheritThemeColors: true,
        description: const Text('Your data has been updated.'),
        animationType: AnimationType.fromLeft,
      ).show(context);
    } catch (e, stackTrace) {
      debugPrint('Update user data error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      CherryToast.error(
        inheritThemeColors: true,
        description: const Text('There is a problem, try again later.'),
        animationType: AnimationType.fromLeft,
      ).show(context);
    } finally {
      loadingProvider.hide();
    }
  }

  Future<void> removeUserProfilePicture() async {
    final loadingProvider = context.read<LoadingProvider>();
    final authProvider = context.read<AuthProvider>();

    loadingProvider.show();

    try {
      final user = authProvider.user!;

      await AuthServices.updateUserData(
        userId: user.id,
        fullName: newUserFullNameController.text.trim(),
        phone: newUserPhoneNumberContoller.text.trim(),
        profilePictureUrl: null,
      );
      await authProvider.loadUser();

      if (!mounted) return;

      CherryToast.success(
        inheritThemeColors: true,
        description: const Text('Your data has been updated.'),
        animationType: AnimationType.fromLeft,
      ).show(context);
    } catch (e, stackTrace) {
      debugPrint('Update user data error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      CherryToast.error(
        inheritThemeColors: true,
        description: const Text('There is a problem, try again later.'),
        animationType: AnimationType.fromLeft,
      ).show(context);
    } finally {
      loadingProvider.hide();
    }
  }

  Future<void> submitUserBecomeAsDriverRequest({
    required String userId,
    required String idCardFile,
    required String criminalRecordFile,
    required String drivingLicenseFile,
    required String carType,
    required String carModel,
    required String carColor,
    required String licensePlate,
    List<String>? carImagesUrl,
  }) async {
    // 1. Upload images to Storage

    final uploadedImages = await DriverStorageService.uploadDriverImages(
      userId: userId,
      idCardPath: idCardFile,
      criminalRecordPath: criminalRecordFile,
      drivingLicensePath: drivingLicenseFile,
      carImagePaths: carImages.map((image) => image.path).toList(),
    );

    await DriverProfileServices.createRequest(
      userId: userId,
      carType: carType,
      carModel: carModel,
      carColor: carColor,
      licensePlate: licensePlate,
      idCardUrl: uploadedImages['id_card_url'],
      criminalRecordUrl: uploadedImages['criminal_record_url'],
      drivingLicenseUrl: uploadedImages['driving_license_url'],
      carImagesUrls: (uploadedImages['car_images'] as List<String>?),
    );

    // // 2. Update existing driver record
    // await DriverProfileServices.updateDriverImages(
    //   userId: userId,
    //   idCardUrl: uploadedImages['id_card_url'],
    //   criminalRecordUrl: uploadedImages['criminal_record_url'],
    //   drivingLicenseUrl: uploadedImages['driving_license_url'],
    //   carImages: (uploadedImages['car_images'] as List<String>?),
    // );
  }

  Future<void> getAppInfo() async {
    appName = context.read<AppInfoProvider>().appName;
    appVersion = context.read<AppInfoProvider>().appVersion;
  }

  @override
  void initState() {
    super.initState();
    getAppInfo();

    _driverBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _driverBoxAnimationController.repeat(reverse: false);
  }

  @override
  void dispose() {
    newUserFullNameController.dispose();
    newUserPhoneNumberContoller.dispose();
    //driver form (car and driver info)
    driverCarType.dispose();
    driverCarModel.dispose();
    driverCarLicensePlateNumbers.dispose();
    driverCarLicensePlateLetters.dispose();
    driverCarColor.dispose();

    // newUserFullNameController.dispose();
    // newUserPhoneNumberContoller.dispose();
    _driverBoxAnimationController.dispose();

    super.dispose();
  }

  bool isUploadImageBtnStart = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!;

    final userId = user.id;
    final userFullName = user.fullName;
    final userEmail = user.email;
    final userPhone = user.phone ?? '';
    final userProfilePicture = user.profilePictureUrl;
    final userSinceDate = user.createdAt;

    final driverProvider = context.watch<DriverProfileProvider>();
    final driverProfile = driverProvider.driver;
    final canBecomeDriver = driverProvider.canBecomeDriver;

    //actions items
    final List<ProfileItemModel> profileSettings = [
      // notifications
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

              _buildHelpExpansionTile(
                icon: Remix.search_line,
                title: 'How do I book a ride?',
                text:
                    'Search for your destination from the home screen, '
                    'choose an available ride, and follow the booking steps.',
              ),

              _buildHelpExpansionTile(
                icon: Remix.car_line,
                title: 'How do I become a driver?',
                text:
                    'Open your profile and select the Become a Driver '
                    'option. Follow the registration steps to submit '
                    'your driver information.',
              ),

              _buildHelpExpansionTile(
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
      ProfileItemModel(
        icon: Remix.information_line,
        title: 'About RideShare',
        subtitle: 'Learn more about the app',
        onTap: () {
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
                title: Text('$appName'),
                subtitle: Text('v$appVersion'),
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

              AppMainButton(onPressed: () {}, title: 'check for updates'),
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
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,

            child: !showBecomeDriverForm
                ? Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppConstColors.subSecondary,
                              AppConstColors.secondary,
                            ],
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
                              leading: userProfilePicture != null
                                  ? CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        userProfilePicture,
                                      ),
                                      onBackgroundImageError:
                                          (exception, stackTrace) => UserAvatar(
                                            name: userFullName,
                                            fontSize: 24,
                                          ),
                                    )
                                  : UserAvatar(
                                      name: userFullName,
                                      fontSize: 24,
                                      radius: 28,
                                    ),
                              title: Text(
                                userFullName.isNotEmpty
                                    ? userFullName
                                    : 'Not added',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppConstColors.white,
                                    ),
                              ),
                              subtitle: Text(
                                userEmail.isNotEmpty ? userEmail : 'Not added',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
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
                                  child: _buildProfileInfoItem(
                                    icon: Remix.phone_fill,
                                    text: userPhone.isNotEmpty
                                        ? userPhone
                                        : 'Not added',
                                  ),
                                ),

                                Expanded(
                                  child: _buildProfileInfoItem(
                                    icon: canBecomeDriver
                                        ? Remix.car_fill
                                        : Remix.user_fill,
                                    text:
                                        'Rider ${canBecomeDriver ? '| Driver' : ''}',
                                  ),
                                ),
                              ],
                            ),
                            // account created at
                            _buildProfileInfoItem(
                              icon: Remix.calendar_event_fill,
                              text:
                                  'joined since (${timeago.format(userSinceDate)})',
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          onPressed: () {
                            newUserFullNameController.text = userFullName;
                            newUserPhoneNumberContoller.text = userPhone;
                            _showEditProfileInfoSheet(
                              context: context,
                              userProfilePictureUrl: userProfilePicture,
                            );
                          },
                          icon: Icon(
                            Remix.pencil_fill,
                            color: AppConstColors.border,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),

          //become as driver box & form
          if (driverProfile == null)
            _becomeAsDriverBoxAndForm(context, userId)
          else
            switch (driverProfile.approvalStatus) {
              DriverApprovalStatus.underReview => _buildUnderReviewStatusCard(),
              DriverApprovalStatus.rejected => _buildRejectedStatusCard(
                rejectedReason: driverProfile.rejectedReason,
              ),
              DriverApprovalStatus.approved => _buildApprovedStatusCard(
                approvedAt: DateFormat(DateFormat.YEAR_MONTH_DAY)
                    .format(driverProfile.approvedAt ?? DateTime.now()),
                carColor: driverProfile.carColor,
                carModel: driverProfile.carModel,
                carType: driverProfile.carType,
                driverRating: driverProfile.driverRating,
                licensePlate: driverProfile.licensePlate,
                onWalletPressed: () {},
                totalRides: driverProfile.totalRides,
              ),
            },
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
                        ?.copyWith(color: AppConstColors.secondaryText),
                  ),

                  trailing: Icon(
                    Remix.arrow_right_s_line,
                    color: AppConstColors.subSecondary,
                  ),
                );
              },

              separatorBuilder: (context, index) {
                return Divider(
                  height: .6,
                  thickness: .6,
                  radius: BorderRadius.circular(30),
                  color: AppConstColors.border,
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          if (driverProfile?.approvalStatus == .approved)
            //delete driver profile button
            AppMainButton(
              onPressed: () => showAppModalSheet(
                context,
                children: [
                  Text(
                    'Delete Driver Profile?',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: AppConstColors.error),
                  ),
                  Text(
                    'Your application and all uploaded documents will be permanently deleted. You will need to submit them again if you apply in the future.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  AppMainButton(
                    onPressed: () async {
                      try {
                        context.read<LoadingProvider>().show();

                        await DriverProfileServices.deleteRequest();

                        if (!context.mounted) return;

                        context.read<DriverProfileProvider>().setDriverProfile =
                            null;

                        context
                                .read<DriverProfileProvider>()
                                .setCanBecomeDriver =
                            false;
                        context.read<AuthProvider>().setMode = UserMode.rider;

                        CherryToast.success(
                          inheritThemeColors: true,
                          description: const Text(
                            'Your driver application has been deleted successfully.',
                          ),
                          animationType: AnimationType.fromLeft,
                        ).show(context);

                        Navigator.pop(context);
                      } catch (e) {
                        if (!context.mounted) return;

                        CherryToast.error(
                          inheritThemeColors: true,
                          description: const Text(
                            'Failed to delete your driver application. Please try again later.',
                          ),
                          animationType: AnimationType.fromLeft,
                        ).show(context);
                      } finally {
                        if (context.mounted) {
                          context.read<LoadingProvider>().hide();
                        }
                      }
                    },
                    title: 'Yes, Delete',
                    icon: Remix.delete_bin_line,
                    mainColor: AppConstColors.error,
                    btnHeign: 44,
                  ),
                  AppMainButton(
                    onPressed: () => Navigator.pop(context),
                    title: 'Cancel',
                    mainColor: AppConstColors.accent,
                    isOutlined: true,
                    btnHeign: 44,
                  ),
                ],
              ),
              title: "delete your driver profile",
              mainColor: AppConstColors.accent,
              showDecoration: false,
              btnHeign: 44,
              isOutlined: true,
            ),

          //logout button
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
                  'Are you sure you want to sign out of your account?',
                  textAlign: .center,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: Colors.grey),
                ),
                AppMainButton(
                  onPressed: () async {
                    try {
                      context.read<LoadingProvider>().show();
                      await AuthServices.signOut();
                      if (!context.mounted) return;

                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.loginScreen,
                      );
                    } catch (e) {
                      CherryToast.error(
                        inheritThemeColors: true,
                        description: const Text(
                          "An unexpected problem occurred, please try again later.",
                        ),
                        animationType: AnimationType.fromLeft,
                      ).show(context);
                    } finally {
                      context.read<LoadingProvider>().hide();
                    }
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

  RepaintBoundary _becomeAsDriverBoxAndForm(
    BuildContext context,
    String userId,
  ) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _driverBoxAnimationController,
        builder: (context, child) {
          final double value = _driverBoxAnimationController.value;
          final double offset = -3.0 + (value * 6.0);

          return Container(
            padding: showBecomeDriverForm ? .zero : const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: showBecomeDriverForm
                  ? null
                  : Border.all(
                      color: AppConstColors.accent.withValues(alpha: 0.6),
                    ),
              color: showBecomeDriverForm ? AppConstColors.white : null,
              gradient: showBecomeDriverForm
                  ? null
                  : LinearGradient(
                      begin: Alignment(offset - 1.2, offset - 1.2),
                      end: Alignment(offset + 1.2, offset + 1.2),
                      colors: [
                        Colors.white,
                        const Color.fromARGB(255, 255, 249, 235),
                        const Color.fromARGB(255, 255, 212, 131),
                        const Color.fromARGB(255, 255, 249, 235),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                    ),
              boxShadow: showBecomeDriverForm
                  ? null
                  : [
                      BoxShadow(
                        color: AppConstColors.shadow.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: child,
          );
        },
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
                  color: showBecomeDriverForm
                      ? AppConstColors.subSecondary
                      : AppConstColors.accent,
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
              trailing: showBecomeDriverForm
                  ? IconButton(
                      tooltip: 'Back',
                      onPressed: () {
                        criminalRecord = null;
                        idCard = null;
                        drivingLicense = null;
                        setState(() {
                          showBecomeDriverForm = false;
                        });
                      },
                      icon: const Icon(Remix.close_line),
                    )
                  : null,
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
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: showBecomeDriverForm
                  ? Form(
                      key: driverFormState,
                      child: Column(
                        spacing: 18,
                        children: [
                          CustomDivider(title: "vehicle properties"),
                          AppTextFormField(
                            labelText: "car type",
                            controller: driverCarType,
                            inputColor: AppConstColors.primaryText,
                            fontSize: 16,
                            inputAction: .next,
                            mainColor: AppConstColors.subSecondary,

                            prefixIcon: Icon(
                              Remix.car_fill,
                              size: 18,
                              color: AppConstColors.subSecondary,
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (text.isEmpty) {
                                return 'Car type is required';
                              }

                              if (text.length < 2) {
                                return 'Car type is too short';
                              }

                              return null;
                            },
                          ),

                          AppTextFormField(
                            controller: driverCarModel,
                            inputColor: AppConstColors.primaryText,
                            fontSize: 16,
                            inputAction: .next,
                            mainColor: AppConstColors.subSecondary,
                            labelText: "car model",
                            prefixIcon: Icon(
                              Icons.model_training_rounded,
                              size: 18,
                              color: AppConstColors.subSecondary,
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (text.isEmpty) {
                                return 'Car model is required';
                              }

                              if (text.length < 2) {
                                return 'Car model is too short';
                              }

                              return null;
                            },
                          ),
                          //car color
                          AppTextFormField(
                            controller: driverCarColor,
                            inputColor: AppConstColors.primaryText,
                            fontSize: 16,
                            inputAction: .next,
                            mainColor: AppConstColors.subSecondary,
                            labelText: "car color",
                            prefixIcon: Icon(
                              Remix.paint_brush_fill,
                              size: 18,
                              color: AppConstColors.subSecondary,
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (text.isEmpty) {
                                return 'Car color is required';
                              }

                              if (text.length < 3) {
                                return 'Enter a valid color';
                              }

                              return null;
                            },
                          ),

                          //car plate
                          Row(
                            spacing: 12,
                            children: [
                              //numbers
                              Expanded(
                                child: AppTextFormField(
                                  controller: driverCarLicensePlateNumbers,
                                  mainColor: AppConstColors.subSecondary,
                                  labelText: "Plate number",
                                  inputColor: AppConstColors.primaryText,
                                  fontSize: 16,
                                  inputAction: .next,
                                  textAlign: .center,
                                  // prefixIcon: Icon(
                                  //   Remix.id_card_fill,
                                  //   size: 18,
                                  //   color: AppConstColors.secondary,
                                  // ),
                                  hintText: "1 2 3",
                                  maxLength: 4,
                                  keyboardType: .number,
                                  validator: (value) {
                                    final text = value?.trim() ?? '';

                                    if (text.isEmpty) {
                                      return 'Numbers must not exceed 4 digits.';
                                    }

                                    final regex = RegExp(r'^[0-9٠-٩]{1,4}$');

                                    if (!regex.hasMatch(text)) {
                                      return 'Numbers must not exceed 4 digits.';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  controller: driverCarLicensePlateLetters,
                                  mainColor: AppConstColors.subSecondary,
                                  labelText: "Plate letters",

                                  inputColor: AppConstColors.primaryText,
                                  fontSize: 16,
                                  maxLength: 5,
                                  inputFormatters: [
                                    LicensePlateLettersFormatter(),
                                  ],
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  hintText: "أ ب ج",
                                  validator: (value) {
                                    final text =
                                        value?.replaceAll(' ', '') ?? '';

                                    if (text.isEmpty) {
                                      return 'License plate is required';
                                    }

                                    if (!RegExp(r'^[\u0621-\u064A]{1,3}$')
                                        .hasMatch(text)) {
                                      return 'Enter up to 3 Arabic letters.';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          ListenableBuilder(
                            listenable: Listenable.merge([
                              driverCarLicensePlateLetters,
                              driverCarLicensePlateNumbers,
                            ]),
                            builder: (context, child) {
                              return _buildEgyptianLicensePlate(
                                letters: driverCarLicensePlateLetters.text,
                                numbers: driverCarLicensePlateNumbers.text,
                              );
                            },
                          ),

                          CustomDivider(title: "Required Documents"),
                          //upload required iamges
                          _buildUploadSectionFormField(
                            icon: Remix.id_card_fill,
                            title: 'ID card (front face)',
                            image: idCard,

                            onTap: () async {
                              context.read<LoadingProvider>().show();
                              idCard = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (!context.mounted) return;
                              context.read<LoadingProvider>().hide();
                              setState(() {});
                            },
                          ),
                          //criminal record
                          _buildUploadSectionFormField(
                            icon: Remix.file_paper_fill,
                            title: 'criminal record',
                            image: criminalRecord,
                            onTap: () async {
                              context.read<LoadingProvider>().show();

                              criminalRecord = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (!context.mounted) return;
                              context.read<LoadingProvider>().hide();
                              setState(() {});
                            },
                          ),
                          //driver license
                          _buildUploadSectionFormField(
                            icon: Remix.info_card_fill,
                            title: 'driving license',
                            image: drivingLicense,
                            onTap: () async {
                              context.read<LoadingProvider>().show();

                              drivingLicense = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (!context.mounted) return;
                              context.read<LoadingProvider>().hide();
                              setState(() {});
                            },
                          ),
                          CustomDivider(
                            title: "Vehicle Images (${carImages.length} / 3)",
                          ),

                          _buildcarImagesSection(),

                          //submit or back
                          AppMainButton(
                            onPressed: () async {
                              if (!driverFormState.currentState!.validate() ||
                                  idCard == null ||
                                  criminalRecord == null ||
                                  drivingLicense == null) {
                                CherryToast.warning(
                                  title: Text(
                                    "missing fields & documents",
                                    style: TextStyle(
                                      color: AppConstColors.accent,
                                    ),
                                  ),
                                  description: Text(
                                    'please fill all required fields & uploading documents',
                                  ),
                                ).show(context);
                                return;
                              } else if (carImages.isEmpty) {
                                CherryToast.warning(
                                  title: Text(
                                    "missing vehicle images",
                                    style: TextStyle(
                                      color: AppConstColors.accent,
                                    ),
                                  ),
                                  description: Text('add at least 1 car image'),
                                ).show(context);
                                return;
                              }
                              try {
                                context.read<LoadingProvider>().show();
                                await submitUserBecomeAsDriverRequest(
                                  userId: userId,
                                  idCardFile: idCard!.path,
                                  criminalRecordFile: criminalRecord!.path,
                                  drivingLicenseFile: drivingLicense!.path,
                                  carType: driverCarType.text,
                                  carModel: driverCarModel.text,
                                  carColor: driverCarColor.text,
                                  licensePlate:
                                      '${driverCarLicensePlateNumbers.text} ${driverCarLicensePlateLetters.text}',
                                  carImagesUrl: carImages
                                      .map((image) => image.path)
                                      .toList(),
                                );
                                if (!context.mounted) return;

                                CherryToast.success(
                                  title: Text(
                                    "done",
                                    style: TextStyle(
                                      color: AppConstColors.approved,
                                    ),
                                  ),
                                  description: Text(
                                    "your request now under review",
                                  ),
                                ).show(context);
                                // set value for driver profile data
                                final driver =
                                    await DriverProfileServices.loadDriverProfileData();
                                if (driver == null) return;
                                if (!context.mounted) return;
                                context
                                        .read<DriverProfileProvider>()
                                        .setDriverProfile =
                                    driver;

                                // clear fields
                                idCard = criminalRecord = drivingLicense = null;
                                carImages = [];
                                driverCarModel.text = driverCarColor.text =
                                    driverCarType.text = '';
                                driverCarLicensePlateLetters.text =
                                    driverCarLicensePlateNumbers.text = '';
                                setState(() {
                                  showBecomeDriverForm = false;
                                });
                              } catch (e) {
                                if (!context.mounted) return;
                                CherryToast.error(
                                  title: Text(
                                    "Error",
                                    style: TextStyle(
                                      color: AppConstColors.error,
                                    ),
                                  ),
                                  description: Text(e.toString()),
                                ).show(context);
                              } finally {
                                if (context.mounted) {
                                  context.read<LoadingProvider>().hide();
                                }
                              }
                            },
                            title: 'send request',
                            mainColor: AppConstColors.subSecondary,
                            icon: Remix.send_plane_line,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Remix.information_line,
                          color: AppConstColors.accent,
                          size: 19,
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: Text(
                            'You’ll need to provide your personal and vehicle information.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black, height: 1.5),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 18),
            // Divider(),

            if (!showBecomeDriverForm)
              AppMainButton(
                onPressed: () {
                  setState(() {
                    showBecomeDriverForm = true;
                  });
                },

                title: 'Register as a Driver',
                mainColor: AppConstColors.accent,
                fontSize: 16,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditProfileInfoSheet({
    required BuildContext context,
    String? userProfilePictureUrl,
  }) async {
    final fullName = newUserFullNameController.text.trim();
    final phoneNumber = newUserPhoneNumberContoller.text.trim();

    final isProfilePictureChanged = ValueNotifier<bool>(false);
    newUserProfilePicture = null;
    try {
      await showAppModalSheet(
        context,
        children: [
          Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Update your personal information.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppConstColors.secondaryText),
          ),

          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isProfilePictureChanged,
                builder: (context, changed, child) {
                  return CircleAvatar(
                    radius: 36,
                    backgroundColor: AppConstColors.input,
                    backgroundImage: changed && newUserProfilePicture != null
                        ? FileImage(File(newUserProfilePicture!.path))
                        : userProfilePictureUrl != null
                        ? NetworkImage(userProfilePictureUrl)
                        : null,
                    child: !changed && userProfilePictureUrl == null
                        ? const Icon(
                            Remix.user_line,
                            color: AppConstColors.secondary,
                            size: 32,
                          )
                        : null,
                  );
                },
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  context.read<LoadingProvider>().show();

                  try {
                    final pickedImage = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedImage == null) return;

                    newUserProfilePicture = pickedImage;

                    isProfilePictureChanged.value =
                        pickedImage.path != userProfilePictureUrl;
                  } catch (e) {
                    if (!context.mounted) return;
                    CherryToast.error(description: Text(e.toString()))
                        .show(context);
                  } finally {
                    if (context.mounted) {
                      context.read<LoadingProvider>().hide();
                    }
                  }
                },

                icon: PhosphorIcon(
                  PhosphorIconsFill.cameraRotate,
                  color: AppConstColors.secondary,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  CherryToast.info(
                    toastDuration: Duration(seconds: 8),
                    title: Text(
                      "remove profile picture ?",
                      style: TextTheme.of(context).labelLarge!.copyWith(
                        color: AppConstColors.primaryText,
                        fontWeight: .bold,
                      ),
                    ),

                    action: Text(
                      'remove',
                      style: TextTheme.of(context).labelLarge!.copyWith(
                        color: AppConstColors.error,
                        fontWeight: .bold,
                      ),
                    ),
                    actionHandler: () async {
                      await removeUserProfilePicture();
                    },
                  ).show(context);
                },
                icon: PhosphorIcon(
                  PhosphorIconsLight.trash,
                  color: AppConstColors.error,
                ),
              ),
            ],
          ),

          Form(
            key: newUserDataFormState,
            child: Column(
              spacing: 14,
              children: [
                AppTextFormField(
                  controller: newUserFullNameController,
                  inputAction: TextInputAction.next,
                  labelText: 'Full Name',
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),

                AppTextFormField(
                  controller: newUserPhoneNumberContoller,
                  keyboardType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  maxLength: 11,
                  labelText: 'Phone Number',
                  validator: (value) {
                    final phone = value?.trim() ?? '';

                    if (phone.isEmpty) return null;

                    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          ListenableBuilder(
            listenable: Listenable.merge([
              newUserFullNameController,
              newUserPhoneNumberContoller,
              isProfilePictureChanged,
            ]),
            builder: (context, child) {
              final hasChanges =
                  fullName != newUserFullNameController.text.trim() ||
                  phoneNumber != newUserPhoneNumberContoller.text.trim() ||
                  isProfilePictureChanged.value;

              return AppMainButton(
                onPressed: hasChanges
                    ? () async {
                        if (!newUserDataFormState.currentState!.validate()) {
                          return;
                        }

                        await saveUserNewData();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    : null,
                title: 'Save Changes',
                icon: Remix.save_line,
              );
            },
          ),
        ],
      );
    } finally {
      isProfilePictureChanged.dispose();
    }
  }

  Widget _buildcarImagesSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: carImages.length < 3 ? carImages.length + 1 : 3,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        // Add image button
        if (index == 0 && carImages.length < 3) {
          return InkWell(
            onTap: () async {
              try {
                context.read<LoadingProvider>().show();
                if (carImages.length >= 3) return;

                final XFile? image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 100,
                );

                if (image == null || !context.mounted) return;

                setState(() {
                  carImages.add(image);
                });
              } catch (e) {
                CherryToast.error(
                  title: Text('error'),
                  description: Text(e.toString()),
                ).show(context);
              } finally {
                context.read<LoadingProvider>().hide();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: AppConstColors.input,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, size: 30, color: Colors.grey),
            ),
          );
        }

        // Calculate actual image index
        final imageIndex = carImages.length < 3 ? index - 1 : index;

        final image = carImages[imageIndex];

        // Display selected image
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(image.path), fit: BoxFit.cover),
            ),

            // Remove image button
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    carImages.removeAt(imageIndex);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApprovedStatusCard({
    required double driverRating,
    required int totalRides,
    required String approvedAt,
    required String carType,
    required String carModel,
    required String carColor,
    required String licensePlate,
    required VoidCallback onWalletPressed,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Approved Account
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppConstColors.accent.withValues(alpha: .15),
                AppConstColors.accent.withValues(alpha: .05),
              ],
            ),
            border: .all(color: AppConstColors.accent, width: 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConstColors.accent.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Remix.shield_check_fill,
                    color: AppConstColors.accent,
                    size: 25,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Approved Driver',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppConstColors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Approved on $approvedAt\n'
                  'Your driver account is approved. You can now offer rides and earn money.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppConstColors.secondaryText,
                  ),
                ),
              ),
              // Text(
              //   ,
              //   style: theme.textTheme.bodySmall?.copyWith(
              //     color: AppConstColors.primaryText,
              //   ),
              // ),

              AppMainButton(
                onPressed: onWalletPressed,
                title: 'My Wallet',
                mainColor: AppConstColors.accent,
                btnHeign: 46,
                isOutlined: true,
                icon: Remix.wallet_3_line,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Driver Statistics
        Row(
          children: [
            Expanded(
              child: _buildDriverStat(
                icon: Remix.star_fill,
                value: driverRating.toStringAsFixed(1),
                label: 'Driver Rating',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDriverStat(
                icon: Remix.car_fill,
                value: totalRides.toString(),
                label: 'Completed Rides',
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // Vehicle Details
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppConstColors.subSecondary.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Vehicle',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstColors.subSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Remix.checkbox_circle_fill,
                    color: AppConstColors.approved,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'reviewed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppConstColors.approved,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildVehicleTableRow('Car Type', carType),
              _buildVehicleTableRow('Model', carModel),
              _buildVehicleTableRow('Color', carColor),
              _buildVehicleTableRow('License Plate', licensePlate),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstColors.accent.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstColors.accent, size: 22),
              const SizedBox(width: 10),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppConstColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTableRow(String label, String value) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppConstColors.subSecondary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderReviewStatusCard() {
    const Color primaryColor = AppConstColors.subSecondary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppConstColors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Remix.time_fill, color: primaryColor, size: 24),
            ),
            title: Text(
              'Application Under Review',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              'We are reviewing your application',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your application is currently being reviewed by our team. We will notify you once the review is complete.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.grey.shade700, height: 1.5),
          ),

          const SizedBox(height: 16),

          _buildStatusMessage(
            color: primaryColor,
            icon: Remix.shield_check_line,
            message: 'Your documents are being verified.',
          ),

          const SizedBox(height: 16),

          Column(
            spacing: 8,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              AppMainButton(
                btnHeign: 44,
                showDecoration: false,
                onPressed: () async {
                  try {
                    final driverProfileApprovalStatusInProvider = context
                        .read<DriverProfileProvider>()
                        .driver!
                        .approvalStatus;

                    final driverProfileApprovalStatusInSupabase =
                        await DriverProfileServices.getDriverApprovalStatus();

                    if (driverProfileApprovalStatusInSupabase !=
                        driverProfileApprovalStatusInProvider) {
                      if (!mounted) return;

                      context.read<DriverProfileProvider>().setDriverProfile =
                          await DriverProfileServices.loadDriverProfileData();

                      if (!mounted) return;

                      if (driverProfileApprovalStatusInSupabase == .approved) {
                        CherryToast.success(
                          toastDuration: Duration(seconds: 4),
                          title: Text(
                            "Congratulations",
                            style: TextStyle(
                              color: AppConstColors.approved,
                              fontWeight: .bold,
                            ),
                          ),
                          description: Text(
                            "Your application as a driver has been approved",
                          ),
                        ).show(context);
                      } else {
                        CherryToast.info(title: Text("response deliverd"))
                            .show(context);
                      }

                      return;
                    }

                    if (!mounted) return;

                    CherryToast.info(
                      title: Text(
                        "Still ${driverProfileApprovalStatusInSupabase.name}",
                      ),
                    ).show(context);
                  } catch (e) {
                    if (!mounted) return;

                    CherryToast.error(
                      title: Text("error"),
                      description: Text(
                        "try again, If the problem persists, restart the application.\n${e.toString()}",
                      ),
                      action: Text('restart app'),
                      actionHandler: () => Phoenix.rebirth(context),
                    ).show(context);
                  }
                },
                title: 'Check Request Status',
                fontSize: 16,
              ),

              AppMainButton(
                onPressed: () {
                  CherryToast.error(
                    toastDuration: Duration(seconds: 8),
                    title: Text(
                      "Confirm delete your request",
                      style: TextTheme.of(context).labelLarge!.copyWith(
                        color: AppConstColors.primaryText,
                        fontWeight: .bold,
                      ),
                    ),
                    description: Text(
                      "Delete your application and all submitted documents? You'll need to reapply to become a driver.",
                      style: TextTheme.of(context).labelMedium!
                          .copyWith(color: AppConstColors.secondaryText),
                    ),
                    action: Text(
                      'confirm delete',
                      style: TextTheme.of(context).labelLarge!.copyWith(
                        color: AppConstColors.error,
                        fontWeight: .bold,
                      ),
                    ),
                    actionHandler: () async {
                      try {
                        context.read<LoadingProvider>().show();
                        await DriverProfileServices.deleteRequest();

                        if (!mounted) return;

                        context.read<DriverProfileProvider>().setDriverProfile =
                            null;

                        if (!mounted) return;

                        CherryToast.success(
                          title: Text("deleted successfully"),
                          description: Text('you can now send another one'),
                        ).show(context);
                      } catch (e) {
                        if (!mounted) return;

                        CherryToast.error(
                          title: Text("error"),
                          description: Text(e.toString()),
                          action: Text('try again'),
                        ).show(context);
                      } finally {
                        if (mounted) {
                          context.read<LoadingProvider>().hide();
                        }
                      }
                    },
                  ).show(context);
                },
                title: 'delete request',
                mainColor: AppConstColors.error,
                isOutlined: true,
                btnHeign: 44,
                showDecoration: false,
                icon: Remix.delete_bin_2_line,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedStatusCard({String? rejectedReason}) {
    const Color primaryColor = AppConstColors.error;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppConstColors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Remix.file_close_fill, color: primaryColor, size: 24),
            ),
            title: Text(
              'Application Rejected',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              'Your application needs attention',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Unfortunately, your driver application could not be approved.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.grey.shade700, height: 1.5),
          ),

          const SizedBox(height: 16),

          if (rejectedReason?.trim().isNotEmpty ?? false) ...[
            Text(
              'Reason for rejection',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              rejectedReason!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey.shade800, height: 1.5),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusMessage({
    required Color color,
    required IconData icon,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpExpansionTile({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      iconColor: AppConstColors.subSecondary,
      textColor: AppConstColors.subSecondary,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Text(text, style: Theme.of(context).textTheme.labelMedium),
        ),
      ],
    );
  }

  Widget _buildProfileInfoItem({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppConstColors.white.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(icon, color: AppConstColors.accent, size: 16),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppConstColors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSectionFormField({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    XFile? image,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppConstColors.white.withValues(alpha: .3),
        border: Border.all(color: AppConstColors.secondaryText, width: .3),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, size: 26, color: AppConstColors.subSecondary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          image != null ? 'Image selected' : 'Tap to upload an image',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: image != null
                ? AppConstColors.approved
                : AppConstColors.subSecondary,
          ),
        ),
        trailing: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.file(File(image.path), fit: BoxFit.cover),
                ),
              )
            : Icon(
                Icons.upload_file_outlined,
                color: AppConstColors.secondaryText,
                size: 26,
              ),
      ),
    );
  }

  Widget _buildEgyptianLicensePlate({
    required String letters,
    required String numbers,
  }) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color(0xFF0F64A5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'EGYPT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'مصر',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      numbers.toArabicNumbers().split('').reversed.join(' '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.grey.shade400,
                  ),
                  Expanded(
                    child: Text(
                      letters,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LicensePlateLettersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final letters = newValue.text.replaceAll(RegExp(r'\s'), '');

    final filtered = String.fromCharCodes(
      letters.runes.where(
        (rune) =>
            RegExp(r'[\u0621-\u064A]').hasMatch(String.fromCharCode(rune)),
      ),
    );

    final limited = filtered.runes.take(3).toList();
    final formatted = limited.map(String.fromCharCode).join(' ');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
