import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:ride_share/core/constants/app_constants.dart';
import 'package:ride_share/core/models/driver_profile_model.dart';
import 'package:ride_share/core/models/ride_model.dart';
import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/models/vehicle_model.dart';
import 'package:ride_share/core/providers/auth_provider.dart';
import 'package:ride_share/core/widgets/default_body.dart';
import 'package:ride_share/core/widgets/my_trips_ride_card.dart';
import 'package:ride_share/core/widgets/rides_filter_chip.dart';

final UserModel driverUser1 = UserModel(
  id: 'user_driver_1',
  fullName: 'Ahmed Mohamed',
  email: 'ahmed@example.com',
  phone: '01012345678',
  currentMode: UserMode.driver,
  createdAt: DateTime(2025, 5, 10),
);

final UserModel driverUser2 = UserModel(
  id: 'user_driver_2',
  fullName: 'Omar Ali',
  email: 'omar@example.com',
  phone: '01123456789',
  currentMode: UserMode.driver,
  createdAt: DateTime(2025, 6, 15),
);

final UserModel rider1 = UserModel(
  id: 'user_rider_1',
  fullName: 'Mohamed Hassan',
  email: 'mohamed@example.com',
  phone: '01098765432',
  createdAt: DateTime(2026, 1, 12),
);

final UserModel rider2 = UserModel(
  id: 'user_rider_2',
  fullName: 'Youssef Ahmed',
  email: 'youssef@example.com',
  phone: '01198765432',
  createdAt: DateTime(2026, 2, 20),
);

final UserModel rider3 = UserModel(
  id: 'user_rider_3',
  fullName: 'Mostafa Ali',
  email: 'mostafa@example.com',
  phone: '01234567890',
  createdAt: DateTime(2026, 3, 5),
);

final DriverProfileModel driver1 = DriverProfileModel(
  id: 'driver_profile_1',
  userId: driverUser1.id,
  idCardUrl: 'https://example.com/id-card-1.jpg',
  criminalRecordUrl: 'https://example.com/criminal-record-1.jpg',
  approvalStatus: DriverApprovalStatus.approved,
  driverRating: 4.8,
  totalRides: 127,
  approvedAt: DateTime(2025, 6, 1),
);

final DriverProfileModel driver2 = DriverProfileModel(
  id: 'driver_profile_2',
  userId: driverUser2.id,
  idCardUrl: 'https://example.com/id-card-2.jpg',
  criminalRecordUrl: 'https://example.com/criminal-record-2.jpg',
  approvalStatus: DriverApprovalStatus.approved,
  driverRating: 4.6,
  totalRides: 89,
  approvedAt: DateTime(2025, 7, 10),
);

final VehicleModel car1 = VehicleModel(
  id: 'vehicle_1',
  driverId: driver1.id,
  plateNumber: 'ASS 1234',
  make: 'Toyota',
  model: 'Corolla',
  color: 'White',
  year: 2022,
  carImageUrl: 'https://example.com/car-1.jpg',
  isActive: true,
);

final VehicleModel car2 = VehicleModel(
  id: 'vehicle_2',
  driverId: driver2.id,
  plateNumber: 'ASS 5678',
  make: 'Hyundai',
  model: 'Elantra',
  color: 'Black',
  year: 2021,
  carImageUrl: 'https://example.com/car-2.jpg',
  isActive: true,
);

final List<RideModel> rides = [
  RideModel(
    from: 'Assiut',
    destination: 'New Assiut',
    departureDate: DateTime(2026, 9, 27, 9, 30),
    stopPoints: ['Assiut University', 'Al-Waleediya'],
    totalSeats: 4,
    distance: 12.5,
    driver: driver1,
    riders: [rider1, rider2],
    car: car1,
    price: 50,
    status: RideStatus.active,
  ),

  RideModel(
    from: 'New Assiut',
    destination: 'Assiut',
    departureDate: DateTime(2026, 9, 27, 14, 0),
    stopPoints: ['Assiut University'],
    totalSeats: 4,
    distance: 13.2,
    driver: driver2,
    riders: [rider1, rider2, rider3],
    car: car2,
    price: 60,
    status: RideStatus.full,
  ),

  RideModel(
    from: 'Assiut',
    destination: 'Dronka',
    departureDate: DateTime(2026, 9, 28, 8, 0),
    stopPoints: ['Al-Mansheya', 'Dronka Road'],
    totalSeats: 4,
    distance: 18.7,
    driver: driver1,
    riders: [rider3],
    car: car1,
    price: 70,
    status: RideStatus.active,
  ),

  RideModel(
    from: 'Assiut',
    destination: 'Manfalut',
    departureDate: DateTime(2026, 9, 25, 10, 30),
    stopPoints: ['Al-Qusiya'],
    totalSeats: 4,
    distance: 42.0,
    driver: driver2,
    riders: [rider1, rider2, rider3],
    car: car2,
    price: 100,
    status: RideStatus.completed,
  ),

  RideModel(
    from: 'New Assiut',
    destination: 'Assiut',
    departureDate: DateTime(2026, 9, 29, 7, 45),
    stopPoints: ['Assiut University', 'Al-Azhar Street'],
    totalSeats: 4,
    distance: 13.5,
    driver: driver1,
    riders: [rider1, rider3],
    car: car1,
    price: 55,
    status: RideStatus.cancelled,
  ),
];

class MyTripsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  RideStatus? selectedStatus;

  late List<RideModel> shownRides;

  @override
  void initState() {
    shownRides = rides;
    super.initState();
  }

  void _filterRides(RideStatus? status) {
    setState(() {
      selectedStatus = status;

      shownRides = status == null
          ? rides
          : rides.where((ride) => ride.status == status).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        // filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [
              ChoiceChip(
                avatar: Icon(
                  Remix.grid_line,
                  size: 16,
                  color: selectedStatus == null
                      ? AppConstColors.secondary
                      : AppConstColors.secondaryText,
                ),
                label: const Text("All"),
                selected: selectedStatus == null,
                showCheckmark: false,
                selectedColor: AppConstColors.subSecondary.withValues(
                  alpha: .2,
                ),
                backgroundColor: AppConstColors.surface,
                side: BorderSide(
                  color: selectedStatus == null
                      ? AppConstColors.subSecondary
                      : AppConstColors.secondaryText,
                ),
                labelStyle: TextStyle(
                  color: selectedStatus == null
                      ? AppConstColors.secondary
                      : AppConstColors.secondaryText,
                  fontWeight: selectedStatus == null
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                onSelected: (_) => _filterRides(null),
              ),
              // RideStatusFilterChip(
              //   status: RideStatus.full,
              //   icon: Remix.group_fill,
              //   selectedStatus: selectedStatus,
              //   onSelected: (_) => _filterRides(RideStatus.full),
              // ),
              RideStatusFilterChip(
                status: RideStatus.active,
                icon: Remix.loader_2_line,
                selectedStatus: selectedStatus,
                onSelected: (_) => _filterRides(RideStatus.active),
              ),
              RideStatusFilterChip(
                status: RideStatus.completed,
                icon: Remix.check_line,
                selectedStatus: selectedStatus,
                onSelected: (_) => _filterRides(RideStatus.completed),
              ),

              RideStatusFilterChip(
                status: RideStatus.cancelled,
                icon: Remix.close_circle_line,
                selectedStatus: selectedStatus,
                onSelected: (_) => _filterRides(RideStatus.cancelled),
              ),
            ],
          ),
        ),

        Expanded(
          child: RefreshIndicator.adaptive(
            color: AppConstColors.secondary,
            backgroundColor: AppConstColors.surface,
            onRefresh: () async {},
            child: Center(
              child: rides.isEmpty
                  ? DefaultBody(
                      imagePath: AppConstImages.notFoundYet,
                      title: "No Rides Found",
                      subtitle: "No available rides match your current search. Try refreshing or changing your pickup location.",
                    )
                  : ListView.builder(
                      itemCount: shownRides.length,
                      itemBuilder: ((context, index) {
                        return RideCardMyTrips(rideData: shownRides[index]);
                      }),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
