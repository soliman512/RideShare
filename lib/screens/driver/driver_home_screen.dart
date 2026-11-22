import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/custom_divider.dart';
import 'package:ride_share/core/widgets/default_body.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List rides = [];

    return Column(
      spacing: 24,
      children: [
        if (rides.isNotEmpty) ...[
          _buildTopBar(context),
          CustomDivider(title: "Next Rides"),
        ],
        Expanded(
          child: rides.isEmpty
              ? Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  spacing: 36,
                  children: [
                    const DefaultBody(
                      imagePath: AppConstImages.driverHomeCenteralShape,
                      title: "No Rides Yet",
                      subtitle: "You haven't created any rides yet. Start by creating your first ride and connect with passengers heading your way.",
                    ),
                    // const Spacer(),
                    AppMainButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.createRideScreen,
                      ),
                      // isOutlined: true,
                      title: 'New Ride',
                      mainColor: AppConstColors.accent,
                    ),
                    // const Spacer(),
                  ],
                )
              : ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    return const SizedBox();
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      spacing: 4,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildTopInfoTile(
                  context,
                  leadingIcon: PhosphorIconsFill.star,
                  title: '2.4',
                ),
              ),
              Expanded(
                child: _buildTopInfoTile(
                  context,
                  leadingIcon: PhosphorIconsFill.car,
                  title: '14',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AppMainButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.createRideScreen),
            title: 'New Ride',
            mainColor: AppConstColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildTopInfoTile(
    BuildContext context, {
    required IconData leadingIcon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // color: AppConstColors.input,
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(
        //   color: AppConstColors.secondaryText.withValues(alpha: 0.12),
        // ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(leadingIcon, color: AppConstColors.accent, size: 21),

          const SizedBox(width: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).labelLarge!.copyWith(
              color: AppConstColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
