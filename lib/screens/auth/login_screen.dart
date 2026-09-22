import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/constants/app_routes.dart';
import 'package:rider_share/extension/app_extensions.dart';
import 'package:rider_share/widgets/app_button.dart';
import 'package:rider_share/widgets/app_name.dart';
import 'package:rider_share/widgets/app_text_form_field.dart';

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

  void outCar() {
    if (mounted) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          // open = false;
          carPosition = CarPosition.right;
        });
      });
    }
  }

  @override
  void initState() {
    enterCar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: .bottomCenter,
        children: [
          Image.asset(
            AppConstImages.welcomeBackground,
            fit: .cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // main box
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            bottom: open ? 0 : -context.screenHeight * .7,
            child: Container(
              clipBehavior: .none,
              padding: .all(20),
              width: context.screenWidth,
              height: context.screenHeight * .7,
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
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .center,
                      // mainAxisSize: .min,
                      children: [
                        //welcome
                        Row(
                          spacing: 6,
                          children: [
                            Image.network(
                              "https://media.lordicon.com/icons/wired/outline/2319-hand-hello.gif",
                              width: 20,
                              height: 20,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox();
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                            ),
                            Text(
                              "Welcome to",
                              style: GoogleFonts.outfit(
                                color: AppConstColors.primaryBlack,
                                fontSize: 18,
                                fontWeight: .w700,
                              ),
                              textAlign: .start,
                            ),
                            const Spacer(),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: Text(
                            //     "اللغة العربية",
                            //     style: GoogleFonts.cairo(
                            //       color: AppConstColors.primaryBlack,
                            //       fontSize: 14,
                            //     ),
                            //     textAlign: .start,
                            //   ),
                            // ),
                          ],
                        ),
                        // const Spacer(flex: 1),
                        SizedBox(height: 40),
                        //appLogo
                        Image.asset(AppConstImages.appLogo, width: 60),
                        SizedBox(height: 8),
                        // appName
                        AppName(),
                        //subtitle
                        Text(
                          "find a ride or share your journey",
                          textAlign: .center,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color:Colors.grey ),
                        ),
                        const SizedBox(height: 60),
                        //form - email field
                        Form(
                          key: formState,
                          child: AppTextFormField(
                            controller: emailController,
                            hintText: "example@email.com",
                            keyboardType: .emailAddress,
                            labelText: "Email address",
                            prefixIcon: Icon(Remix.mail_send_line),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "ⓘ Email address is required";
                              } else if (!value.contains("@") ||
                                  !value.contains(".com")) {
                                return "ⓘ use a valid email address";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // send code button
                        SizedBox(
                          width: double.infinity,
                          child: AppMainButton(
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                outCar();

                                await Future.delayed(
                                  const Duration(milliseconds: 1100),
                                );

                                if (!context.mounted) return;
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.verifyOtpScreen,
                                );
                              }
                            },
                            title: "Send Code",
                            icon: Remix.send_ins_fill,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // note
                        Text(
                          "We'll send a verification code to your email\naddress.",
                          textAlign: .center,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color:Colors.grey ),
                        ),
                        // const Spacer(flex: 2),
                      ],
                    ),
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
