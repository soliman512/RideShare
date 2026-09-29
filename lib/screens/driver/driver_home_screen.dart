import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/constants/app_routes.dart';
import 'package:ride_share/core/models/ride_model.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/custom_divider.dart';
import 'package:ride_share/core/widgets/driver_home_ride_card.dart';

class DriverHomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RideModel> rides = [];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        spacing: 12,
        children: [
          Row(
            spacing: 6,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              DriverHomeTargetInfoBox(
                title: "Rating",
                icon: Remix.star_fill,
                value: "4.8",
              ),

              DriverHomeTargetInfoBox(
                title: "Total Trips",
                icon: Remix.route_fill,
                value: "24",
              ),

              // DriverHomeTargetInfoBox(
              //   title: "Passengers",
              //   icon: Remix.group_fill,
              //   value: "48",
              // ),
            ],
          ),
          AppMainButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createRideScreen);
            },
            title: "Create Ride",
            icon: Remix.road_map_fill,
          ),
          const SizedBox.shrink(),
          CustomDivider(title: "All Rides"),
          const SizedBox.shrink(),

          ...List.generate(
            rides.length,
            ((index) => RideCardDriverHome(rideData: rides[index])),
          ),
        ],
      ),
    );
  }
}

class DriverHomeTargetInfoBox extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  final String title;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(12),
          boxShadow: [
            BoxShadow(
              color: AppConstColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppConstColors.border, width: 1.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: AppConstColors.accent),

            const SizedBox(width: 8),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstColors.primaryText,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppConstColors.secondaryText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
