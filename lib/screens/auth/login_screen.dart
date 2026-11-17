import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/extension/keyboard_status_extension.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/supabase_services/auth_services.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/app_name.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum CarPosition { left, center, right }

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool open = false;
  CarPosition carPosition = CarPosition.left;
  void enterCar() {
    if (mounted) {
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          open = true;
          carPosition = CarPosition.center;
        });
      });
      Future.delayed(Duration(milliseconds: 4000), () {
        setState(() {
          carPosition = CarPosition.center;
        });
      });
    }
  }

  Future<void> outCar() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      carPosition = CarPosition.right;
    });
  }

  @override
  void initState() {
    enterCar();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = context.isKeyboardOpen;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: .bottomCenter,
        children: [
          //background
          Image.asset(
            AppConstImages.welcomeBackground,
            fit: .cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // main box
          // Container(width: 200, height: 200, color: Colors.green),
          AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            left: 0,
            right: 0,
            bottom: open ? 0 : -context.screenHeight * .7,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              clipBehavior: .none,
              padding: .all(20),
              width: context.screenWidth,
              constraints: BoxConstraints(
                minHeight: context.screenHeight * .64,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Visibility(
                    visible: !isKeyboardOpen,
                    child: AnimatedPositioned(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      top: -70,
                      left: switch (carPosition) {
                        CarPosition.left => -200,
                        CarPosition.center => (context.screenWidth - 100) / 2,
                        CarPosition.right => context.screenWidth + 200,
                      },
                      child: Image.asset(AppConstImages.car, width: 100),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: .center,

                    // mainAxisSize: .min,
                    children: [
                      //welcome
                      Row(
                        spacing: 6,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.network(
                                "https://media.lordicon.com/icons/wired/outline/2319-hand-hello.gif",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const SizedBox.shrink();
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          Text(
                            "Welcome to",
                            style: GoogleFonts.outfit(
                              color: AppConstColors.primaryText,
                              fontSize: 18,
                              fontWeight: .w700,
                            ),
                            textAlign: .start,
                          ),
                          // const Spacer(),
                          // TextButton(
                          //   onPressed: () {},
                          //   child: Text(
                          //     "اللغة العربية",
                          //     style: GoogleFonts.cairo(
                          //       color: AppConstColors.secondaryText,
                          //       fontSize: 14,
                          //     ),
                          //     textAlign: .start,
                          //   ),
                          // ),
                        ],
                      ),
                      // const Spacer(flex: 1),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: isKeyboardOpen ? 60 : 20,
                      ),
                      //appLogo
                      Image.asset(AppConstImages.appLogo, width: 50),
                      SizedBox(height: 8),
                      // appName
                      AppName(),
                      //subtitle
                      Text(
                        "find a ride or share your journey",
                        textAlign: .center,
                        style: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: AppConstColors.secondaryText),
                      ),
                      SizedBox(height: 20),
                      //form - email field
                      Form(
                        key: formState,
                        child: AppTextFormField(
                          controller: emailController,
                          hintText: "example@email.com",
                          keyboardType: .emailAddress,
                          labelText: "Email address",
                          prefixIcon: Icon(
                            Remix.mail_send_line,
                            color: AppConstColors.secondary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ⓘ Email address is required";
                            } else if (!value.contains("@")) {
                              return "ⓘ use a valid email address";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // send code button
                      AppMainButton(
                        isLoading: isLoading,
                        onPressed: () async {
                          if (!formState.currentState!.validate()) return;

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final email = emailController.text.trim();

                            context.read<AuthProvider>().setUserEmail = email;

                            // Send OTP and wait for Supabase response
                            await AuthServices.signInWithEmailOtp(email);
                            await outCar();
                            if (!context.mounted) return;

                            // Navigate only if sending request succeeds
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.verifyOtpScreen,
                              (route) => false,
                            );
                          } on AuthException catch (e) {
                            if (!context.mounted) return;

                            CherryToast.error(
                              inheritThemeColors: true,
                              description: Text(e.message),
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
                            if (context.mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        title: "Send Code",
                        icon: Remix.send_ins_fill,
                      ),

                      const SizedBox(height: 10),
                      // already have the code
                      AppMainButton(
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            final email = emailController.text.trim();

                            context.read<AuthProvider>().setUserEmail = email;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.verifyOtpScreen,
                            );
                          }
                        },
                        showDecoration: false,
                        btnHeign: 44,
                        isOutlined: true,
                        title: "I Have the Code",
                        mainColor: AppConstColors.secondary.withValues(
                          alpha: .5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // note
                      Text(
                        "We'll send a verification code to your email\naddress.",
                        textAlign: .center,
                        style: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: AppConstColors.secondaryText),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(
                      //       context,
                      //       AppRoutes.verifyOtpScreen,
                      //     );
                      //   },
                      //   child: const Text(
                      //     'I Have the Code',
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w600,
                      //       color: Color(0xFF0F64A5),
                      //     ),
                      //   ),
                      // ),
                      // const Spacer(flex: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
