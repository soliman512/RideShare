import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/providers/loading_provider.dart';
import 'package:ride_share/core/widgets/default_body.dart';

class RiderHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  String greeting = 'Hi';

  String getCurrentGreeting() {
    int currentTimeHour = DateTime.now().hour;
    switch (currentTimeHour) {
      case >= 5 && < 12:
        return 'Good Morning';
      case >= 12 && < 18:
        return 'Good Afternoon';
      case >= 18 && < 24:
        return 'Good Evening';
    }
    return 'Hi';
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    greeting = getCurrentGreeting();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProviderWatch = context.watch<AuthProvider>();

    final user = authProviderWatch.getUser;
    String userFullName = 'Unkoun';
    if (user == null) {
      context.watch<LoadingProvider>().show();
    } else {
      context.watch<LoadingProvider>().hide();
      userFullName = user.fullName.split(' ').take(1).join();
    }
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppConstColors.primaryText),
                children: [
                  TextSpan(text: "$greeting, "),
                  TextSpan(
                    text: userFullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppConstColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Where are you going?",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 26,
                color: AppConstColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Find a ride to your destination.",
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 28),
            //search field
            TextField(
              controller: searchController,
              // focusNode: focusNode,
              // keyboardType: keyboardType,
              textInputAction: .search,
              // onChanged: onChange,
              // obscureText: obscureText,
              cursorColor: AppConstColors.subSecondary,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppConstColors.primaryText),
              textAlign: .start,
              decoration: InputDecoration(
                hintText: "ex. New Cairo",
                labelText: "\t\tSearch\t\t",
                // prefixIcon: Icon(
                //   Remix.map_pin_2_fill,
                //   color: AppConstColors.primaryText,
                // ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Remix.search_2_line, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstColors.accent,
                      foregroundColor: Colors.white,
                      padding: const .all(4),
                      alignment: .center,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(255, 143, 143, 143),
                  fontWeight: FontWeight.w300,
                ),

                floatingLabelAlignment: .center,
                floatingLabelBehavior: .always,
                labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstColors.accent,
                  fontWeight: FontWeight.w300,
                ),
                filled: true,
                fillColor: AppConstColors.accent.withValues(alpha: 0.02),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(
                    color: AppConstColors.primaryText,
                    width: 2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(
                    color: AppConstColors.primaryText,
                    width: 2,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppConstColors.accent,
                    width: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: DefaultBody(
                imagePath: AppConstImages.riderHomeCenteralShape,
                title: "Your next ride is a search away",
                subtitle: "Enter your destination above to find the\nbest rides near you.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
