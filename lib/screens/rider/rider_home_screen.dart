import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/extension/app_extensions.dart';

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
                style: GoogleFonts.outfit(
                  color: AppConstColors.primaryBlack,
                  fontSize: 18,
                ),
                children: [
                  const TextSpan(text: "Good Morning, "),
                  TextSpan(
                    text: "soliman",
                    style: GoogleFonts.outfit(
                      color: AppConstColors.orange,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Where are you going?",
              style: GoogleFonts.outfit(
                fontSize: 26,
                color: AppConstColors.primaryBlack,
                fontWeight: .w600,
              ),
            ),
            Text(
              "Find a ride to your destination.",
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: const Color.fromARGB(255, 156, 156, 156),
              ),
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
              cursorColor: AppConstColors.secondary,
              style: GoogleFonts.outfit(
                color: AppConstColors.primaryBlack,
                fontSize: 16,
              ),
              textAlign: .center,
              decoration: InputDecoration(
                hintText: "ex. New Cairo",
                labelText: "\t\tSearch\t\t",
                prefixIcon: Icon(
                  Remix.map_pin_2_fill,
                  color: AppConstColors.primaryBlack,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Remix.search_2_line, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstColors.orange,
                      foregroundColor: Colors.white,
                      padding: const .all(4),
                      alignment: .center,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                hintStyle: GoogleFonts.outfit(
                  color: const Color.fromARGB(255, 143, 143, 143),
                  fontWeight: .w300,
                  fontSize: 14,
                ),

                floatingLabelAlignment: .center,
                floatingLabelBehavior: .always,
                labelStyle: GoogleFonts.outfit(
                  color: AppConstColors.orange,
                  fontWeight: .w300,
                  fontSize: 18,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 250, 250),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(
                    color: AppConstColors.primaryBlack,
                    width: 2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(
                    color: AppConstColors.primaryBlack,
                    width: 2,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppConstColors.orange,
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
