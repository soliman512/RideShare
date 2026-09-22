import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/widgets/app_button.dart';
import 'package:rider_share/widgets/app_text_form_field.dart';

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
                Align(
                  alignment: .topStart,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      crossAxisAlignment: .center,
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        Icon(
                          Remix.edit_circle_line,
                          color: AppConstColors.secondary,
                        ),
                        Text(
                          "change email",
                          style: GoogleFonts.outfit(
                            color: AppConstColors.primaryBlack,
                            fontSize: 16,
                          ),
                          textAlign: .start,
                        ),
                      ],
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
                    color: AppConstColors.secondary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Enter the 6-digit code sent to\nuser@example.com",
                  style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
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
                              return '*';
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
                            .copyWith(color: Colors.grey),

                        textAlign: .center,
                      ),
                    ),
                    TextButton(
                      onPressed: timer.value == 0
                          ? () {
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
                              : Colors.grey,
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
                //     style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
                //     children: [
                //       const TextSpan(text: "Resend in\t\t"),
                //       TextSpan(
                //         text: "00:42",
                //         style: GoogleFonts.outfit(
                //           fontWeight: .bold,
                //           color: AppConstColors.secondary,
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
                          .copyWith(color: Colors.grey),
                    ),
                    ValueListenableBuilder(
                      valueListenable: timer,
                      builder: (context, value, child) => Text(
                        "00:${timer.value.toString().padLeft(2, "0")}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: .bold,
                          color: AppConstColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // send code button
                SizedBox(
                  width: double.infinity,
                  child: AppMainButton(
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.profileSetupScreen,
                        );
                      }
                    },

                    title: "Verify",
                    icon: Remix.mail_check_fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
