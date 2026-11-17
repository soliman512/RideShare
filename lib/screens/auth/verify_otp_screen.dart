import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
  List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  ValueNotifier<int> timer = ValueNotifier<int>(59);
  ValueNotifier<bool> sureBack = ValueNotifier<bool>(false);
  bool isButtonLoading = false;

  Timer? _timer;
  void resendInTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (timer.value > 0) {
        timer.value--;
      } else {
        setState(() {});
        _timer!.cancel();
      }
    });
  }

  @override
  void initState() {
    resendInTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (TextEditingController element in otpControllers) {
      element.dispose();
    }
    for (FocusNode element in otpFocusNodes) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? userEmail = context.read<AuthProvider>().userEmail;
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
                  Align(
                    alignment: .topStart,
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Change email?'),
                              content: const Text(
                                'Are you sure you want to go back and change your email address?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);

                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.loginScreen,
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Change email'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Remix.edit_circle_line,
                        color: AppConstColors.subSecondary,
                        size: 19,
                      ),
                      label: Text(
                        'Change email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Image.asset(AppConstImages.verifyEmailGif, width: 200),
                  SizedBox(height: 12),
                  Text(
                    "Verify your email",
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: .w700,
                      color: AppConstColors.subSecondary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Enter the 6-digit code sent to\n ${userEmail ?? "email@example.com"}",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: AppConstColors.secondaryText,
                    ),
                    textAlign: .center,
                  ),
                  SizedBox(height: 22),
                  //fields
                  Form(
                    key: formState,

                    child: Row(
                      spacing: 6,
                      children: List.generate(
                        6,
                        ((index) => Expanded(
                          child: AppTextFormField(
                            controller: otpControllers[index],
                            focusNode: otpFocusNodes[index],
                            onChange: (value) {
                              if (value.isNotEmpty) {
                                if (index < otpFocusNodes.length - 1) {
                                  otpFocusNodes[index + 1].requestFocus();
                                }
                              } else {
                                if (index > 0) {
                                  otpFocusNodes[index - 1].requestFocus();
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' *';
                              } else {
                                return null;
                              }
                            },
                            inputAction: .done,
                            keyboardType: .number,
                            maxLength: 1,
                            showCursor: false,
                            fontSize: 24,
                            fontWeight: .bold,

                            textAlign: .center,
                          ),
                        )),
                      ),
                    ),
                  ),

                  SizedBox(height: 22),
                  //resend code
                  Row(
                    mainAxisAlignment: .center,

                    children: [
                      Flexible(
                        child: Text(
                          "Didn't receive the code?",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: AppConstColors.secondaryText),

                          textAlign: .center,
                        ),
                      ),
                      TextButton(
                        onPressed: timer.value == 0
                            ? () async {
                                try {
                                  await AuthServices.signInWithEmailOtp(
                                    userEmail!,
                                  );
                                } on AuthException catch (e) {
                                  if (!context.mounted) return;
                                  CherryToast.error(
                                    inheritThemeColors: true,
                                    description: Text(e.toString()),
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                }
                                setState(() {
                                  timer.value = 59;
                                  resendInTimer();
                                });
                              }
                            : null,

                        child: Text(
                          "Resend code",
                          style: TextStyle(
                            color: timer.value == 0
                                ? AppConstColors.approved
                                : AppConstColors.secondaryText,
                            fontSize: 14,
                            fontWeight: .w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //time
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     style: GoogleFonts.outfit(fontSize: 16, color: AppConstColors.secondaryText),
                  //     children: [
                  //       const TextSpan(text: "Resend in\t\t"),
                  //       TextSpan(
                  //         text: "00:42",
                  //         style: GoogleFonts.outfit(
                  //           fontWeight: .bold,
                  //           color: AppConstColors.subSecondary,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    spacing: 8,
                    children: [
                      Text(
                        "Resend in",
                        style: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: AppConstColors.secondaryText),
                      ),
                      ValueListenableBuilder(
                        valueListenable: timer,
                        builder: (context, value, child) => Text(
                          "00:${timer.value.toString().padLeft(2, "0")}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: .bold,
                            color: AppConstColors.subSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // send code button
                  AppMainButton(
                    isLoading: isButtonLoading,
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        setState(() {
                          isButtonLoading = true;
                        });
                        try {
                          String otp = '';
                          for (var element in otpControllers) {
                            otp += element.text;
                          }
                          // verify email with check otp
                          await AuthServices.verifyEmailOtp(
                            email: userEmail!,
                            token: otp,
                          );
                          // check if user found in public.users or no to specific the next page to navigate
                          if (await AuthServices.isUserProfileExists()) {
                            if (!context.mounted) return;
                            await context.read<AuthProvider>().loadUser();
                            if (!context.mounted) return;

                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.mainScaffold,
                            );
                          } else {
                            if (!context.mounted) return;

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.profileSetupScreen,
                              (route) => false,
                            );
                          }
                        } on AuthException catch (e) {
                          if (!context.mounted) return;
                          CherryToast.error(
                            inheritThemeColors: true,
                            description: Text(e.message.toString()),
                            animationType: AnimationType.fromTop,
                          ).show(context);
                        } catch (e) {
                          if (!context.mounted) return;
                          CherryToast.error(
                            inheritThemeColors: true,
                            description: Text(e.toString()),
                            animationType: AnimationType.fromTop,
                          ).show(context);
                        } finally {
                          setState(() {
                            isButtonLoading = false;
                          });
                        }
                      }
                    },

                    title: "Verify",
                    icon: Remix.mail_check_fill,
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
