import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:ride_share/core/supabase_services/driver_services.dart';
import 'package:ride_share/core/extension/english_nums_to_arabic_extension.dart';

class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
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
  final List<XFile> carImages = [];
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
          await AuthServices.updateUserProfilePicture(
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
        animationType: AnimationType.fromTop,
      ).show(context);
    } catch (e, stackTrace) {
      debugPrint('Update user data error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      CherryToast.error(
        inheritThemeColors: true,
        description: const Text('There is a problem, try again later.'),
        animationType: AnimationType.fromTop,
      ).show(context);
    } finally {
      loadingProvider.hide();
    }
  }

  Future<void> submitUserBecomeAsDriverRequest({
    required String userId,
    required String idCardUrl,
    required String criminalRecordUrl,
    required String drivingLicenseUrl,
    required String carType,
    required String carModel,
    required String carColor,
    required String licensePlate,
    List<String>? carImagesUrl,
  }) async {
    await DriverServices.createRequest(
      userId: userId,
      idCardUrl: idCardUrl,
      criminalRecordUrl: criminalRecordUrl,
      drivingLicenseUrl: drivingLicenseUrl,
      carType: carType,
      carModel: carModel,
      carColor: carColor,
      licensePlate: licensePlate,
      carImagesUrl: carImagesUrl,
    );
  }

  Future<void> getAppInfo() async {
    appName = context.read<AppInfoProvider>().appName;
    appVersion = context.read<AppInfoProvider>().appVersion;
  }

  Future<void> showVehicleImagePicker() async {
    if (carImages.length >= 3) return;

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? image = await imagePicker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (image == null || !mounted) return;

    setState(() {
      carImages.add(image);
    });
  }

  @override
  void initState() {
    getAppInfo();
    _driverBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _driverBoxAnimationController.repeat(reverse: false);
    super.initState();
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
    final String userId = context.watch<AuthProvider>().user!.id;
    final String userFullName = context.watch<AuthProvider>().user!.fullName;
    final String userEmail = context.watch<AuthProvider>().user!.email;
    final String userPhone =
        context.watch<AuthProvider>().user!.phone ?? 'not found';
    final String? userProfilePicture = context
        .watch<AuthProvider>()
        .user!
        .profilePictureUrl;
    final DateTime userSinceDate = context
        .watch<AuthProvider>()
        .user!
        .createdAt;
    bool canBecomeDriver = context.watch<AuthProvider>().canBecomeDriver;
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
          Stack(
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
                              backgroundImage: NetworkImage(userProfilePicture),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  UserAvatar(name: userFullName, fontSize: 24),
                            )
                          : UserAvatar(
                              name: userFullName,
                              fontSize: 24,
                              radius: 28,
                            ),
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
                            text: userPhone.isNotEmpty
                                ? userPhone
                                : 'Not added',
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
                      text: 'joined since (${timeago.format(userSinceDate)})',
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
          ),

          //driver data
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _driverBoxAnimationController,
              builder: (context, child) {
                final double value = _driverBoxAnimationController.value;
                final double offset = -3.0 + (value * 6.0);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
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
                    boxShadow: [
                      BoxShadow(
                        color: AppConstColors.shadow.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
                        color: AppConstColors.accent,
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
                            key: driverFormState,
                            child: Column(
                              spacing: 14,
                              children: [
                                Divider(),
                                AppTextFormField(
                                  outLabel: "car type",
                                  controller: driverCarType,
                                  inputColor: AppConstColors.primaryText,
                                  fontSize: 18,
                                  inputAction: .next,
                                  textAlign: .center,
                                  prefixIcon: Icon(
                                    Remix.car_fill,
                                    size: 18,
                                    color: AppConstColors.secondary,
                                  ),
                                  hintText: "EX: Toyota",
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
                                  fontSize: 18,
                                  inputAction: .next,
                                  textAlign: .center,
                                  outLabel: "car model",
                                  prefixIcon: Icon(
                                    Remix.caravan_fill,
                                    size: 18,
                                    color: AppConstColors.secondary,
                                  ),
                                  hintText: "Camry 2026",
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
                                  fontSize: 18,
                                  inputAction: .next,
                                  textAlign: .center,
                                  outLabel: "car color",
                                  prefixIcon: Icon(
                                    Remix.paint_brush_fill,
                                    size: 18,
                                    color: AppConstColors.secondary,
                                  ),
                                  hintText: "Black",
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
                                        controller:
                                            driverCarLicensePlateNumbers,
                                        outLabel: "License Plate",
                                        inputColor: AppConstColors.primaryText,
                                        fontSize: 18,
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

                                          final regex = RegExp(
                                            r'^[0-9٠-٩]{1,4}$',
                                          );

                                          if (!regex.hasMatch(text)) {
                                            return 'Numbers must not exceed 4 digits.';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller:
                                            driverCarLicensePlateLetters,
                                        outLabel: "License Plate",

                                        inputColor: AppConstColors.primaryText,
                                        fontSize: 18,
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
                                    return EgyptianLicensePlate(
                                      letters:
                                          driverCarLicensePlateLetters.text,
                                      numbers:
                                          driverCarLicensePlateNumbers.text,
                                    );
                                  },
                                ),

                                CustomDivider(title: "Required Documents"),
                                //upload required iamges
                                UploadSectionFormField(
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
                                UploadSectionFormField(
                                  icon: Remix.file_paper_fill,
                                  title: 'criminal record',
                                  image: criminalRecord,
                                  onTap: () async {
                                    context.read<LoadingProvider>().show();

                                    criminalRecord = await imagePicker
                                        .pickImage(source: ImageSource.gallery);
                                    if (!context.mounted) return;
                                    context.read<LoadingProvider>().hide();
                                    setState(() {});
                                  },
                                ),
                                //driver license
                                UploadSectionFormField(
                                  icon: Remix.info_card_fill,
                                  title: 'driving license',
                                  image: drivingLicense,
                                  onTap: () async {
                                    context.read<LoadingProvider>().show();

                                    drivingLicense = await imagePicker
                                        .pickImage(source: ImageSource.gallery);
                                    if (!context.mounted) return;
                                    context.read<LoadingProvider>().hide();
                                    setState(() {});
                                  },
                                ),
                                CustomDivider(title: "Vehicle Images"),

                                buildcarImagesSection(),

                                //submit or back
                                Row(
                                  spacing: 12,
                                  children: [
                                    IconButton(
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
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppMainButton(
                                        onPressed: () async {
                                          if (!driverFormState.currentState!
                                                  .validate() ||
                                              idCard == null ||
                                              criminalRecord == null ||
                                              drivingLicense == null) {
                                            CherryToast.warning(
                                              title: Text(
                                                "missing fields",
                                                style: TextStyle(
                                                  color: AppConstColors.accent,
                                                ),
                                              ),
                                              description: Text(
                                                'please fill all required fields',
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
                                              description: Text(
                                                'add at least 1 car image',
                                              ),
                                            ).show(context);
                                            return;
                                          }
                                          try {
                                            context
                                                .read<LoadingProvider>()
                                                .show();
                                            await submitUserBecomeAsDriverRequest(
                                              userId: userId,
                                              idCardUrl: idCard!.path,
                                              criminalRecordUrl:
                                                  criminalRecord!.path,
                                              drivingLicenseUrl:
                                                  drivingLicense!.path,
                                              carType: driverCarType.text,
                                              carModel: driverCarModel.text,
                                              carColor: driverCarColor.text,
                                              licensePlate:
                                                  '${driverCarLicensePlateNumbers.text} ${driverCarLicensePlateLetters.text}',
                                              carImagesUrl: carImages
                                                  .map((image) => image.path)
                                                  .toList(),
                                            );
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
                                              context
                                                  .read<LoadingProvider>()
                                                  .hide();
                                              CherryToast.success(
                                                title: Text(
                                                  "done",
                                                  style: TextStyle(
                                                    color:
                                                        AppConstColors.approved,
                                                  ),
                                                ),
                                                description: Text(
                                                  "your request now under review",
                                                ),
                                              ).show(context);
                                            }
                                          }
                                        },
                                        title: 'Submit',
                                        mainColor: AppConstColors.secondary,
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
                                color: AppConstColors.accent,
                                size: 19,
                              ),

                              const SizedBox(width: 9),

                              Expanded(
                                child: Text(
                                  'You’ll need to provide your personal and vehicle information.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.black,
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
                        animationType: AnimationType.fromTop,
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

  Future<void> _showEditProfileInfoSheet({
    required BuildContext context,
    String? userProfilePictureUrl,
  }) async {
    final fullName = newUserFullNameController.text.trim();
    final phoneNumber = newUserPhoneNumberContoller.text.trim();

    final isProfilePictureChanged = ValueNotifier<bool>(false);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isProfilePictureChanged,
                builder: (context, changed, child) {
                  return CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    backgroundImage: changed && newUserProfilePicture != null
                        ? FileImage(File(newUserProfilePicture!.path))
                        : userProfilePictureUrl != null
                        ? NetworkImage(userProfilePictureUrl)
                        : null,
                    child: !changed && userProfilePictureUrl == null
                        ? const Icon(Remix.user_line, size: 32)
                        : null,
                  );
                },
              ),

              ElevatedButton(
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
                    CherryToast.error(description: Text(e.toString()));
                  } finally {
                    if (context.mounted) {
                      context.read<LoadingProvider>().hide();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Select New Picture'),
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

  Widget buildcarImagesSection() {
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
            onTap: showVehicleImagePicker,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
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
              borderRadius: BorderRadius.circular(12),
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

class UploadSectionFormField extends StatelessWidget {
  const UploadSectionFormField({
    required this.icon,
    required this.title,
    required this.onTap,
    this.image,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppConstColors.white.withValues(alpha: .3),
        border: Border.all(color: AppConstColors.secondary, width: .3),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(icon, size: 26, color: AppConstColors.secondary),
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
                : AppConstColors.secondary,
          ),
        ),
        trailing: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.file(File(image!.path), fit: BoxFit.cover),
                ),
              )
            : Icon(
                Icons.upload_file_outlined,
                color: AppConstColors.subSecondary,
                size: 26,
              ),
      ),
    );
  }
}

class EgyptianLicensePlate extends StatelessWidget {
  final String letters;
  final String numbers;

  const EgyptianLicensePlate({
    super.key,
    required this.letters,
    required this.numbers,
  });

  @override
  Widget build(BuildContext context) {
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

            Container(
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
