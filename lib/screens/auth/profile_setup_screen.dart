import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/services/auth_services.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/show_app_modal_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();
  bool isButtonLoading = false;
  XFile? profilePicture;
  final ImagePicker imagePicker = ImagePicker();

  //animate the back image
  late AnimationController _spinController;
  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    fullName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  /// user model
  ///  final String id;
  // final String fullName;
  // final String email;
  // final String? phone;
  // final UserMode currentMode;
  // final DateTime createdAt;

Future<void> saveUserProfileData({
  required String userFullName,
  String? phoneNumber,
  required bool isLoggedIn,
}) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    throw Exception('User is not authenticated');
  }

  // 1. Upload profile picture
  String? profilePicUrl;

  if (profilePicture != null) {
    profilePicUrl = await AuthServices.uploadProfilePicture(
      userId: user.id,
      imagePath: profilePicture!.path,
    );
  }

  // 2. Create user profile
  await AuthServices.createUserProfile(
    fullName: userFullName,
    phone: phoneNumber,
    profilePictureUrl: profilePicUrl,
  );

  // 3. Update auth user metadata
  await AuthServices.updateAuthUser(
    fullName: userFullName,
    phone: phoneNumber,
  );


}

  ValueNotifier<String> userAvatar = ValueNotifier<String>("");
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const .all(20),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  // header
                  Row(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Image.asset(AppConstImages.appLogo, width: 40),
                      Text(
                        "setup your profile",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      // const Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  // profile image (character)
                  Stack(
                    alignment: .center,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: AnimatedBuilder(
                              animation: _spinController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      _spinController.value *
                                      2 *
                                      3.141592653589793,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                AppConstImages.doodles,
                                color: AppConstColors.subSecondary.withValues(
                                  alpha: .7,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withValues(alpha: .9),
                            backgroundImage: profilePicture != null
                                ? FileImage(File(profilePicture!.path))
                                : null,
                            child: profilePicture == null
                                ? ValueListenableBuilder(
                                    valueListenable: userAvatar,
                                    builder: (context, value, child) {
                                      if (value.isEmpty) {
                                        return profilePicture == null
                                            ? Icon(
                                                Remix.emotion_happy_line,
                                                fill: 0.6,
                                                size: 70,
                                                color: AppConstColors.secondary,
                                              )
                                            : const SizedBox.shrink();
                                      }
                                      return Text(
                                        value,
                                        style: TextStyle(
                                          color: AppConstColors.subSecondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                        ),
                                      );
                                    },
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                showAppModalSheet(
                                  context,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildImageSourceOption(
                                            context,
                                            icon: Remix.camera_line,
                                            title: 'Open camera',
                                            onTap: () async {
                                              try {
                                                profilePicture =
                                                    await imagePicker.pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                    );
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.toString()),
                                                  ),
                                                );
                                              } finally {
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                setState(() {});
                                              }
                                              // Open camera
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: _buildImageSourceOption(
                                            context,
                                            icon: Remix.gallery_line,
                                            title: 'Choose from gallery',
                                            onTap: () async {
                                              try {
                                                profilePicture =
                                                    await imagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                    );
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.toString()),
                                                  ),
                                                );
                                              } finally {
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                                setState(() {});
                                              }
                                              // Open camera
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppConstColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Remix.camera_line,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  //title
                  Text(
                    "Tell us a little about yourself",
                    textAlign: .center,
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(color: AppConstColors.subSecondary),
                  ),
                  //desctiption
                  Text(
                    "Enter your full name and phone number\nto complete your profile.",
                    textAlign: .center,
                    style: Theme.of(context).textTheme.labelMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: formState,
                    child: Column(
                      spacing: 20,
                      children: [
                        //fullName
                        AppTextFormField(
                          controller: fullName,
                          inputAction: .next,
                          keyboardType: .text,
                          onChange: (value) {
                            userAvatar.value = value.trim().isEmpty
                                ? ''
                                : value
                                      .trim()
                                      .split(RegExp(r'\s+'))
                                      .take(2)
                                      .map((e) => e[0])
                                      .join()
                                      .toUpperCase();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ⓘ full name is required";
                            } else {
                              return null;
                            }
                          },
                          labelText: "full name",
                          prefixIcon: Icon(
                            Remix.user_5_fill,
                            color: AppConstColors.subSecondary,
                          ),
                        ),
                        //phoneNumber
                        AppTextFormField(
                          controller: phoneNumber,
                          maxLength: 11,
                          inputAction: .done,
                          keyboardType: .number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }

                            if (!value.startsWith("010") &&
                                !value.startsWith("011") &&
                                !value.startsWith("012") &&
                                !value.startsWith("015")) {
                              return "ⓘ Please enter a valid phone number";
                            }
                            if (value.length != 11) {
                              return "ⓘ Please enter a valid phone number";
                            }

                            return null;
                          },
                          labelText: "phone number (optional)",
                          prefixIcon: Icon(
                            Remix.phone_fill,
                            color: AppConstColors.subSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  AppMainButton(
                    isLoading: isButtonLoading,
                    onPressed: () async{
                      setState(() {
                        isButtonLoading = true;
                      });
                      if (formState.currentState!.validate()) {
                
                        try {
                         await saveUserProfileData(
                            userFullName: fullName.text,
                            phoneNumber: phoneNumber.text,
                         
                            isLoggedIn: true,
                          );
                          if(!context.mounted) return;
                           Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.mainScaffold,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        } finally {
                          setState(() {
                            isButtonLoading = false;
                          });
                         
                        }
                      }
                    },
                    title: "Save",
                    icon: Remix.save_3_fill,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildImageSourceOption(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Material(
    color: AppConstColors.surface,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstColors.subSecondary.withValues(alpha: .2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppConstColors.accent.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 29, color: AppConstColors.accent),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}
