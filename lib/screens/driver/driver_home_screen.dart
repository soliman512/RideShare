import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/models/rider_model.dart';
import 'package:rider_share/widgets/app_button.dart';

final List<DriverRideData> rides = [
  const DriverRideData(
    destination: "Asyut",
    departureDate: "Mon, Oct 26",
    departureTime: "08:30 AM",
    bookedSeats: 3,
    totalSeats: 4,
    distance: 12.5,
    status: RideStatus.active,
  ),
  const DriverRideData(
    destination: "Mall of Asyut",
    departureDate: "Tue, Oct 27",
    departureTime: "10:00 AM",
    bookedSeats: 4,
    totalSeats: 4,
    distance: 8.2,
    status: RideStatus.full,
  ),
  const DriverRideData(
    destination: "Assiut University",
    departureDate: "Wed, Oct 28",
    departureTime: "07:15 AM",
    bookedSeats: 2,
    totalSeats: 4,
    distance: 6.8,
    status: RideStatus.active,
  ),
  const DriverRideData(
    destination: "Dronka",
    departureDate: "Thu, Oct 29",
    departureTime: "04:30 PM",
    bookedSeats: 0,
    totalSeats: 3,
    distance: 15.4,
    status: RideStatus.cancelled,
  ),
  const DriverRideData(
    destination: "Manfalut",
    departureDate: "Fri, Oct 30",
    departureTime: "09:00 AM",
    bookedSeats: 3,
    totalSeats: 3,
    distance: 25.7,
    status: RideStatus.completed,
  ),
];

class DriverHomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
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

              DriverHomeTargetInfoBox(
                title: "Passengers",
                icon: Remix.group_fill,
                value: "48",
              ),
            ],
          ),
          AppMainButton(
            onPressed: () {},
            title: "Create Ride",
            icon: Remix.road_map_fill,
          ),
          const SizedBox.shrink(),
          Row(
            spacing: 16,
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Divider(
                  color: AppConstColors.secondaryText,
                  thickness: 1,
                  height: 1,
                  radius: .circular(12),
                ),
              ),
              Text(
                "Current Rides",
                style: Theme.of(context).textTheme.labelMedium!
                    .copyWith(color: AppConstColors.secondaryText),
              ),
              Expanded(
                child: Divider(
                  color: AppConstColors.secondaryText,
                  thickness: 1,
                  height: 1,
                  radius: .circular(12),
                ),
              ),
            ],
          ),
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

class RideCardDriverHome extends StatelessWidget {
  const RideCardDriverHome({super.key, required this.rideData});

  final DriverRideData rideData;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(rideData.status);
    final statusText = _getStatusText(rideData.status);

    final seatsProgress = rideData.totalSeats > 0
        ? (rideData.bookedSeats / rideData.totalSeats).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: .all(12),
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
      child: Column(
        spacing: 16,
        children: [
          Column(
            spacing: 4,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 4,
                      children: [
                        Flexible(
                          child: Text(
                            "New Asyut city",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(color: AppConstColors.primaryText),
                          ),
                        ),
                        Icon(
                          Remix.arrow_right_line,
                          color: AppConstColors.subSecondary,
                          size: 20,
                        ),
                        Flexible(
                          child: Text(
                            rideData.destination,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(color: AppConstColors.subSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: .symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: .1),
                      borderRadius: .circular(40),
                    ),
                    child: Text(
                      statusText,
                      style: Theme.of(context).textTheme.bodySmall!
                          .copyWith(color: statusColor),
                    ),
                  ),
                ],
              ),

              Row(
                spacing: 6,
                children: [
                  Icon(
                    Remix.time_line,
                    color: AppConstColors.secondaryText,
                    size: 14,
                  ),
                  Expanded(
                    child: Text(
                      "${rideData.departureDate}"
                      " • "
                      "${rideData.departureTime}",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(color: AppConstColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            spacing: 6,
            children: [
              Icon(Remix.sofa_line, color: AppConstColors.subSecondary),

              Expanded(
                flex: 6,
                child: LinearProgressIndicator(
                  backgroundColor: AppConstColors.surface,
                  borderRadius: .circular(20),
                  minHeight: 24,
                  color: AppConstColors.subSecondary,
                  value: seatsProgress,
                ),
              ),

              Container(
                padding: .symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  border: .all(color: AppConstColors.subSecondary, width: 1),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  "${rideData.bookedSeats}/${rideData.totalSeats}",
                  style: const TextStyle(
                    color: AppConstColors.subSecondary,
                    fontWeight: .w600,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          AppMainButton(
            onPressed: () {},
            title: "See Details",
            isOutlined: true,
            mainColor: AppConstColors.accent,
            icon: Remix.car_fill,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RideStatus status) {
    switch (status) {
      case RideStatus.active:
        return AppConstColors.approved;

      case RideStatus.cancelled:
        return AppConstColors.error;

      case RideStatus.full:
        return AppConstColors.accent;

      case RideStatus.completed:
        return AppConstColors.subSecondary;
    }
  }

  String _getStatusText(RideStatus status) {
    switch (status) {
      case RideStatus.active:
        return "ACTIVE";

      case RideStatus.cancelled:
        return "CANCELLED";

      case RideStatus.full:
        return "FULL";

      case RideStatus.completed:
        return "COMPLETED";
    }
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: AppConstColors.accent),

            const SizedBox(height: 6),

            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstColors.primaryText,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppConstColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
