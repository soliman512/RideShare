import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/models/ride_model.dart';
import 'package:ride_share/core/widgets/custom_divider.dart';
import 'package:ride_share/core/widgets/user_avatar.dart';

class RideCardMyTrips extends StatefulWidget {
  const RideCardMyTrips({super.key, required this.rideData});

  final RideModel rideData;

  @override
  State<RideCardMyTrips> createState() => _RideCardMyTripsState();
}

class _RideCardMyTripsState extends State<RideCardMyTrips> {
  late final ExpansibleController driverCarInfoExpansTileController;
  @override
  void initState() {
    driverCarInfoExpansTileController = ExpansibleController();
    super.initState();
  }

  @override
  void dispose() {
    driverCarInfoExpansTileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departureDate = DateFormat('EEE, MMM d')
        .format(widget.rideData.departureDate);

    final departureTime = DateFormat('hh:mm a')
        .format(widget.rideData.departureDate);
    final statusColor = _getStatusColor(widget.rideData.status);
    final statusText = _getStatusText(widget.rideData.status);

    return Stack(
      alignment: .topRight,
      children: [
        Container(
          padding: .all(12),
          margin: .symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(20),
            boxShadow: [
              BoxShadow(
                color: AppConstColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: statusColor.withValues(alpha: .4),
              width: 1.4,
            ),
          ),
          child: Column(
            spacing: 16,
            children: [
              Column(
                spacing: 12,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      //waiting point
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            "waiting point:",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(color: AppConstColors.secondaryText),
                          ),
                          Flexible(
                            child: Text(
                              widget.rideData.from,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: AppConstColors.primaryText),
                            ),
                          ),
                        ],
                      ),
                      // arrow right -> to
                      Icon(
                        Remix.arrow_right_line,
                        color: statusColor,
                        size: 22,
                      ),
                      // to point
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            "to:",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(color: AppConstColors.secondaryText),
                          ),
                          Flexible(
                            child: Text(
                              widget.rideData.destination,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: statusColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // date and time
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
              CustomDivider(title: "stop points"),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ...List.generate(widget.rideData.stopPoints.length, (index) {
                    final isLast =
                        index == widget.rideData.stopPoints.length - 1;

                    final isFirst = index == 0;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isLast ? statusColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              if (isFirst || isLast)
                                Icon(
                                  Remix.flag_line,
                                  color: isLast ? Colors.white : statusColor,
                                  size: 16,
                                ),

                              Text(
                                widget.rideData.stopPoints[index],
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(
                                      color: isLast
                                          ? Colors.white
                                          : statusColor,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        if (!isLast)
                          Icon(
                            Remix.arrow_right_s_line,
                            color: statusColor,
                            size: 16,
                          ),
                      ],
                    );
                  }),
                ],
              ),
              CustomDivider(title: "driver & car info"),
              ExpansionTile(
                controller: driverCarInfoExpansTileController,
                tilePadding: .symmetric(vertical: 2, horizontal: 8),

                // Background
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: AppConstColors.surface,

                // Shape
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: statusColor.withValues(alpha: .4),
                    width: 1,
                  ),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: UserAvatar(
                  name: widget.rideData.driver.userId,
                  radius: 20,
                  mainColor: statusColor,
                ),
                title: Text(
                  widget.rideData.driver.userId,
                  style: TextTheme.of(context).titleSmall!
                      .copyWith(color: statusColor),
                ),
                subtitle: Text(
                  "01065765512",
                  style: TextTheme.of(context).labelSmall!
                      .copyWith(color: AppConstColors.secondaryText),
                ),
                trailing: FilledButton(
                  onPressed: () {
                    if (driverCarInfoExpansTileController.isExpanded) {
                      driverCarInfoExpansTileController.collapse();
                    } else {
                      driverCarInfoExpansTileController.expand();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: statusColor.withValues(alpha: .05),
                    foregroundColor: statusColor,
                    side: BorderSide(color: statusColor),
                  ),
                  child: Text(
                    "car info",
                    style: TextTheme.of(context).labelLarge!
                        .copyWith(color: statusColor),
                  ),
                ),
                childrenPadding: .all(8),

                children: [
                  Column(
                    spacing: 4,
                    children: [
                      Container(
                        padding: .symmetric(vertical: 4),
                        width: double.infinity,
                        color: AppConstColors.surface,
                        child: Text(
                          "Model: ${widget.rideData.car.model}",
                          textAlign: .center,
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            color: AppConstColors.primaryText,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Expanded(
                            child: Container(
                              padding: .symmetric(vertical: 4),
                              width: double.infinity,
                              color: AppConstColors.surface,
                              child: Text(
                                widget.rideData.car.color,
                                textAlign: .center,
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(
                                      color: AppConstColors.primaryText,
                                      fontWeight: .bold,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: .symmetric(vertical: 4),
                              width: double.infinity,
                              color: AppConstColors.surface,
                              child: Text(
                                widget.rideData.car.plateNumber,
                                textAlign: .center,
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(
                                      color: AppConstColors.primaryText,
                                      fontWeight: .bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // cost & cancelling
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                spacing: 12,
                children: [
                  Expanded(
                    flex: 1,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: AppConstColors.secondary,
                              fontWeight: .bold,
                            ),
                        children: [
                          const TextSpan(text: "148.5"),
                          TextSpan(
                            text: "EGP",
                            style: TextStyle(
                              color: AppConstColors.secondaryText,
                              fontSize: 12,
                              fontWeight: .w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,

                        foregroundColor: AppConstColors.accent,

                        padding: const EdgeInsets.symmetric(vertical: 10),

                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        //   side: BorderSide(color: AppConstColors.error),
                        // ),
                        side: BorderSide(color: AppConstColors.error),
                        overlayColor: AppConstColors.error.withValues(
                          alpha: .12,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(color: AppConstColors.error),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //status
        Positioned(
          top: 24,
          right: 1.2,
          child: Container(
            // padding: .symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: ShapeDecoration(
              color: statusColor.withValues(alpha: .2),
              shape: BeveledRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: AppConstColors.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              statusText,
              style: Theme.of(context).textTheme.labelSmall!
                  .copyWith(color: statusColor),
            ),
          ),
        ),
      ],
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
