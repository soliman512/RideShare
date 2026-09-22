import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/widgets/app_button.dart';
import 'package:rider_share/widgets/app_text_form_field.dart';

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

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> userAvatar = ValueNotifier<String>("");
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
                      style: GoogleFonts.outfit(
                        color: AppConstColors.primaryBlack,
                        fontSize: 14,
                        fontWeight: .w600,
                      ),
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
                      backgroundColor: AppConstColors.white.withValues(
                        alpha: .98,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: userAvatar,
                        builder: (context, value, child) {
                          if (value.isEmpty) {
                            return Icon(
                              Remix.user_5_line,
                              fill: 0.6,
                              size: 70,
                              color: AppConstColors.primaryBlack,
                            );
                          }
                          return Text(
                            value,
                            style: GoogleFonts.outfit(
                              color: AppConstColors.secondary,
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
                  style: GoogleFonts.outfit(
                    color: AppConstColors.secondary,
                    fontSize: 22,
                    fontWeight: .w600,
                  ),
                ),
                //desctiption
                Text(
                  "Enter your full name and phone number\nto complete your profile.",
                  textAlign: .center,
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
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
                          color: AppConstColors.secondary,
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
                          color: AppConstColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                AppMainButton(
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.mainScaffold,
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
