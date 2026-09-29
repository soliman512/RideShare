import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/models/ride_model.dart';
import 'package:ride_share/core/widgets/app_button.dart';

class RideCardDriverHome extends StatelessWidget {
  const RideCardDriverHome({super.key, required this.rideData});

  final RideModel rideData;

  @override
  Widget build(BuildContext context) {
    final departureDate = DateFormat('EEE, MMM d')
        .format(rideData.departureDate);

    final departureTime = DateFormat('hh:mm a').format(rideData.departureDate);
    final statusColor = _getStatusColor(rideData.status);
    final statusText = _getStatusText(rideData.status);

    final seatsProgress = rideData.totalSeats > 0
        ? (rideData.riders.length / rideData.totalSeats).clamp(0.0, 1.0)
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
                            rideData.from,
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
                      "$departureDate • $departureTime",
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
                  "${rideData.riders.length}/${rideData.totalSeats}",
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

          SizedBox(
            child: AppMainButton(
              onPressed: () {},
              title: "See Details",
              isOutlined: true,
              mainColor: AppConstColors.accent,
              icon: Remix.car_fill,
            ),
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
