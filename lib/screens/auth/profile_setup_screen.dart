import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/data/generate_id.dart';
import 'package:ride_share/core/data/mock_database.dart';
import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();
  @override
  void dispose() {
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

  Future<void> getUserModel() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? localId = prefs.getString(AppStorageKeys.userId);
      UserModel user = usersTable.firstWhere((user) => user.id == localId);
      if (!mounted) return;
      context.read<AuthProvider>().setUser = user;
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('getUserModel error: $e');
      // ignore: avoid_print
      print(stackTrace);
    }
  }

  Future<void> saveUserProfileData({
    required String userFullName,
    required String id,
    required String email,
    String? phoneNumber,
    required bool isLoggedIn,
  }) async {
    //save user data in mock database
    usersTable.add(
      UserModel(
        id: id,
        email: email.trim(),
        fullName: userFullName.trim(),
        phone: phoneNumber?.trim(),
        createdAt: DateTime.now(),
      ),
    );
    context.read<LoadingProvider>().show();

    //save user data and is logged state locally
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(AppStorageKeys.userId, id.trim());

    await prefs.setBool(AppStorageKeys.isLoggedIn, isLoggedIn);

    await prefs.setBool(AppStorageKeys.canBecomeDriver, false);
    await getUserModel();
    if (!mounted) return;
    context.read<LoadingProvider>().hide();
    Navigator.pushReplacementNamed(context, AppRoutes.mainScaffold);
  }

  ValueNotifier<String> userAvatar = ValueNotifier<String>("");
  @override
  Widget build(BuildContext context) {
    final String? userEmail = context.watch<AuthProvider>().userEmail;

    return Scaffold(
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
                      backgroundImage: AssetImage(AppConstImages.doodles),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withValues(alpha: .98),
                      child: ValueListenableBuilder(
                        valueListenable: userAvatar,
                        builder: (context, value, child) {
                          if (value.isEmpty) {
                            return Icon(
                              Remix.user_5_line,
                              fill: 0.6,
                              size: 70,
                              color: AppConstColors.primaryText,
                            );
                          }
                          return Text(
                            value,
                            style: TextStyle(
                              color: AppConstColors.subSecondary,
                              fontWeight: .bold,
                              fontSize: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      context.read<AuthProvider>().setUserFullName =
                          fullName.text;
                      context.read<AuthProvider>().setUserPhoneNumber =
                          phoneNumber.text;
                      saveUserProfileData(
                        userFullName: fullName.text,
                        id: generateId(),
                        phoneNumber: phoneNumber.text,
                        email: userEmail ?? "userEmail@notfound.error",
                        isLoggedIn: true,
                      );
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
    );
  }
}
