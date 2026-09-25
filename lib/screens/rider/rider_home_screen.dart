import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';

import '../../widgets/default_body.dart';

class RiderHomeScreen extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontSize: 18, color: AppConstColors.primaryText),
                children: [
                  const TextSpan(text: "Good Morning, "),
                  TextSpan(
                    text: "soliman",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
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
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 40),
            //search field
            TextField(
              controller: searchController,
              // focusNode: focusNode,
              // keyboardType: keyboardType,
              textInputAction: .search,
              // onChanged: onChange,
              // obscureText: obscureText,
              cursorColor: AppConstColors.subSecondary,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: AppConstColors.primaryText),
              textAlign: .center,
              decoration: InputDecoration(
                hintText: "ex. New Cairo",
                labelText: "\t\tSearch\t\t",
                prefixIcon: Icon(
                  Remix.map_pin_2_fill,
                  color: AppConstColors.primaryText,
                ),
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
                    color: AppConstColors.secondary,
                    width: 2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(
                    color: AppConstColors.secondary,
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
