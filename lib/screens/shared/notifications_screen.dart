import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rider_share/constants/app_constants.dart';
import 'package:rider_share/core/urils/app_date_formatter.dart';
import 'package:rider_share/models/notification_model.dart';
import 'package:rider_share/providers/loading_provider.dart';
import 'package:rider_share/widgets/default_body.dart';

class NotificationsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = [
      NotificationModel(
        type: NotificationType.bookingConfirmed,
        title: 'Booking Confirmed',
        body: 'Your booking has been confirmed successfully.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),

      NotificationModel(
        type: NotificationType.rideCancelled,
        title: 'Ride Cancelled',
        body: 'Your ride has been cancelled by the driver.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),

      NotificationModel(
        type: NotificationType.rideCompleted,
        title: 'Ride Completed',
        body: 'Your ride has been completed. Thank you for riding with us!',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      NotificationModel(
        type: NotificationType.reviewReceived,
        title: 'New Review Received',
        body: 'You received a new review from your passenger.',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      NotificationModel(
        type: NotificationType.bookingConfirmed,
        title: 'Booking Confirmed',
        body: 'Your seat has been reserved successfully.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        type: NotificationType.driverCancelled,
        title: 'ride cancelled',
        body: 'Your seat has been reserved successfully.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        foregroundColor: AppConstColors.primaryText,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Remix.arrow_left_wide_fill),
        ),
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.history, color: AppConstColors.error),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: notifications.isEmpty
            ? Center(
                child: DefaultBody(
                  imagePath: AppConstImages.noNotificationsYet,
                  title: "No Notifications yet",
                  subtitle:
                      "You're all caught up! New notifications\n"
                      "will appear here..",
                ),
              )
            : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  final type = notification.type;
                  final title = notification.title;
                  final content = notification.body;
                  final isRead = notification.isRead;
                  final date = notification.createdAt;

                  final notificationColor = getNotificationColor(type);

                  return Dismissible(
                    key: ValueKey(date),
                    direction: DismissDirection.horizontal,

                    background: _buildDismissBackground(
                      alignment: Alignment.centerLeft,
                    ),

                    secondaryBackground: _buildDismissBackground(
                      alignment: Alignment.centerRight,
                    ),

                    onDismissed: (direction) {
                      context.read<LoadingProvider>().show();
                      Timer(Duration(milliseconds: 3000), () {
                        context.read<LoadingProvider>().hide();
                      });

                      setState(() {
                        notifications.remove(notification);
                      });
                    },

                    child: Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                          color: getNotificationColor(type),

                          width: 0.8,
                        ),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification icon
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: getNotificationColor(type)
                                .withValues(alpha: .14),

                            child: Icon(
                              getNotificationIcon(type),
                              color: notificationColor,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: .w700),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppConstColors.primaryText
                                            .withValues(alpha: 0.60),
                                        fontSize: 13,
                                        height: 1.4,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatDate(date),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppConstColors.primaryText
                                          .withValues(alpha: 0.55),
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),

                              const SizedBox(height: 10),

                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,

                                  decoration: const BoxDecoration(
                                    color: Color(0xFF027EF1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

IconData getNotificationIcon(NotificationType type) {
  return switch (type) {
    NotificationType.bookingConfirmed => Remix.calendar_check_fill,

    NotificationType.rideCancelled => Remix.calendar_close_fill,

    NotificationType.rideCompleted => Remix.flag_fill,

    NotificationType.reviewReceived => Remix.star_fill,

    NotificationType.driverCancelled => Remix.user_forbid_fill,
  };
}

Color getNotificationColor(NotificationType type) {
  return switch (type) {
    // Primary Blue
    NotificationType.bookingConfirmed => const Color(0xFF027EF1),

    // Soft Red
    NotificationType.rideCancelled => const Color(0xFFE5484D),

    // Emerald Green
    NotificationType.rideCompleted => const Color(0xFF16A36A),

    // Warm Amber
    NotificationType.reviewReceived => const Color(0xFFD99000),

    // Slate Gray
    NotificationType.driverCancelled => const Color(0xFF525866),
  };
}

Widget _buildDismissBackground({required Alignment alignment}) {
  return Container(
    alignment: alignment,

    padding: const EdgeInsets.symmetric(horizontal: 20),

    decoration: BoxDecoration(
      color: const Color(0xFFE5484D),
      borderRadius: BorderRadius.circular(16),
    ),

    child: const Icon(Remix.delete_bin_6_line, color: Colors.white, size: 24),
  );
}
