import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';
import 'package:ride_share/core/models/location_model.dart';
import 'package:ride_share/core/services/geoapify_service.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/screens/app_scaffold.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  //destination
  List<LocationModel> destinationResults = [];
  final ValueNotifier<bool> isSearchingDestination = ValueNotifier(false);
  LocationModel? selectedDestination;
  //departure
  List<LocationModel> departureResults = [];
  final ValueNotifier<bool> isSearchingDeparture = ValueNotifier(false);
  LocationModel? selectedDeparture;

  final GeoapifyService _geoapifyService = GeoapifyService();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController departureController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final ValueNotifier<int> availableSeats = ValueNotifier<int>(3);

  final ValueNotifier<List<TextEditingController>> pickupPoints = ValueNotifier(
    [TextEditingController()],
  );

  DateTime? departureDate;
  TimeOfDay? departureTime;

  int totalSeats = 3;
  @override
  @override
  void initState() {
    super.initState();

    pickupPoints.addListener(validateFields);
    for (final controller in pickupPoints.value) {
      controller.addListener(validateFields);
    }
  }

  @override
  void dispose() {
    destinationController.dispose();
    departureController.dispose();
    notesController.dispose();
    availableSeats.dispose();
    isSearchingDestination.dispose();
    isSearchingDeparture.dispose();
    for (final controller in pickupPoints.value) {
      controller.dispose();
    }

    pickupPoints.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() => departureDate = selectedDate);
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: departureTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() => departureTime = selectedTime);
    }
  }

  void _addPickupPoint() {
    pickupPoints.value = [...pickupPoints.value, TextEditingController()];
  }

  void _removePickupPoint(int index) {
    if (pickupPoints.value.length <= 1) return;

    final updatedPoints = [...pickupPoints.value];
    final removedController = updatedPoints.removeAt(index);

    pickupPoints.value = updatedPoints;
    removedController.dispose();
  }

  String get formattedDate {
    if (departureDate == null) return 'Select date';

    final date = departureDate!;

    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String get formattedTime {
    return departureTime?.format(context) ?? 'Select time';
  }

  final ValueNotifier<bool> isRequiredFieldNotEmpty = ValueNotifier<bool>(
    false,
  );

  void validateFields() {
    isRequiredFieldNotEmpty.value =
        selectedDestination != null &&
        selectedDeparture != null &&
        pickupPoints.value.every((element) => element.text.isNotEmpty) &&
        totalSeats > 0 &&
        departureDate != null &&
        departureTime != null;
  }

  int _searchDestinationRequestId = 0;

  Future<void> _onDestinationChanged(String value) async {
    final requestId = ++_searchDestinationRequestId;
    if (value.isEmpty) {
      setState(() {
        selectedDestination = null;
        destinationResults = [];
      });
      return;
    }
    if (value.trim().length < 2) {
      destinationResults = [];
      selectedDestination = null;
      isSearchingDestination.value = false;
      validateFields();
      return;
    }

    isSearchingDestination.value = true;
    selectedDestination = null;

    validateFields();

    try {
      final results = await _geoapifyService.searchLocation(value);

      if (!mounted || requestId != _searchDestinationRequestId) return;
      setState(() {
        destinationResults = results;
      });
    } catch (e) {
      if (!mounted || requestId != _searchDestinationRequestId) return;

      CherryToast.error(
        title: const Text('Search Failed'),
        description: const Text('Unable to fetch locations. Please try again.'),
      ).show(context);
    } finally {
      if (mounted && requestId == _searchDestinationRequestId) {
        isSearchingDestination.value = false;
      }
    }
  }

  void _onDestinationSelected(LocationModel location) {
    setState(() {
      selectedDestination = location;
      destinationController.text = location.address;
      destinationResults = [];
    });

    validateFields();
  }

  // start point (departureResults)
  int _searchDepartureRequestId = 0;

  Future<void> _onDepartureChanged(String value) async {
    final requestId = ++_searchDepartureRequestId;
    if (value.isEmpty) {
      setState(() {
        selectedDeparture = null;
        departureResults = [];
      });
      return;
    }
    if (value.trim().length < 2) {
      departureResults = [];
      selectedDeparture = null;
      isSearchingDeparture.value = false;
      validateFields();
      return;
    }

    isSearchingDeparture.value = true;
    selectedDeparture = null;

    validateFields();

    try {
      final results = await _geoapifyService.searchLocation(value);

      if (!mounted || requestId != _searchDepartureRequestId) return;
      setState(() {
        departureResults = results;
      });
    } catch (e) {
      if (!mounted || requestId != _searchDepartureRequestId) return;

      CherryToast.error(
        title: const Text('Search Failed'),
        description: const Text('Unable to fetch locations. Please try again.'),
      ).show(context);
    } finally {
      if (mounted && requestId == _searchDepartureRequestId) {
        isSearchingDeparture.value = false;
      }
    }
  }

  void _onDepartureSelected(LocationModel location) {
    setState(() {
      selectedDeparture = location;
      departureController.text = location.address;
      departureResults = [];
    });

    validateFields();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: .fromLTRB(20, 40, 20, 20),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),

            const SizedBox(height: 36),
            // Form Content
            _buildSectionTitle('Destination', Icons.location_on_rounded),

            ValueListenableBuilder<bool>(
              valueListenable: isSearchingDestination,
              builder: (context, isSearching, child) {
                return AppTextFormField(
                  controller: destinationController,
                  hintText: 'Enter destination',
                  onChange: (value) => _onDestinationChanged(value),
                  inputAction: .search,
                  textAlign: .center,
                  suffixIcon: isSearching
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppConstColors.secondaryText,
                            ),
                          ),
                        )
                      : selectedDestination != null
                      ? PhosphorIcon(
                          PhosphorIconsBold.check,
                          color: AppConstColors.subSecondary,
                        )
                      : destinationController.text.isNotEmpty
                      ? PhosphorIcon(
                          PhosphorIconsBold.question,
                          color: AppConstColors.accent,
                        )
                      : null,
                );
              },
            ),

            //search result
            if (destinationResults.isNotEmpty)
              _showSearchLocationResults(
                context,
                results: destinationResults,
                isDestination: true,
              ),
            const SizedBox(height: 24),

            ///////////////////////////////////////////////////////
            // departure:
            _buildSectionTitle('Departure', Icons.location_on_rounded),

            ValueListenableBuilder<bool>(
              valueListenable: isSearchingDeparture,
              builder: (context, isSearching, child) {
                return AppTextFormField(
                  controller: departureController,
                  hintText: 'Enter departure point',
                  onChange: (value) => _onDepartureChanged(value),
                  inputAction: .search,
                  textAlign: .center,
                  suffixIcon: isSearching
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppConstColors.secondaryText,
                            ),
                          ),
                        )
                      : selectedDeparture != null
                      ? PhosphorIcon(
                          PhosphorIconsBold.check,
                          color: AppConstColors.subSecondary,
                        )
                      : departureController.text.isNotEmpty
                      ? PhosphorIcon(
                          PhosphorIconsBold.question,
                          color: AppConstColors.accent,
                        )
                      : null,
                );
              },
            ),

            //search result
            if (departureResults.isNotEmpty)
              _showSearchLocationResults(
                context,
                results: departureResults,
                isDestination: false,
              ),
            const SizedBox(height: 24),

            if (selectedDestination != null && selectedDeparture != null) ...[
              const SizedBox(height: 12),

              FutureBuilder(
                future: _geoapifyService.calculateDistanceInKm(
                  selectedDeparture!,
                  selectedDestination!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text('Failed to calculate distance');
                  }
                  if (snapshot.hasData) {
                    final distance = snapshot.data!;
                    final grossEarning = distance * 5;
                    final platformFees = grossEarning * 0.10;
                    final driverEarning = grossEarning - platformFees;
                    return ListenableBuilder(
                      listenable: Listenable.merge([
                        destinationController,
                        departureController,
                      ]),
                      builder: (context, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: const ValueKey('destination_info'),
                            spacing: 8,
                            children: [
                              _buildDestinationInfoRow(
                                context,
                                icon: Icons.route_outlined,
                                title: 'Total Distance',
                                subtitle: 'Total trip distance',
                                number: distance,
                                unit: 'km',
                              ),

                              _buildDestinationInfoRow(
                                context,
                                icon: Icons.account_balance_wallet_outlined,
                                title: 'Gross Earnings',
                                subtitle: 'Total ride amount',
                                number: grossEarning,
                                unit: 'EGP',

                                color: AppConstColors.subSecondary,
                              ),

                              _buildDestinationInfoRow(
                                context,
                                icon: Icons.receipt_long_outlined,
                                title: 'Platform Fees',
                                subtitle: '5 EGP per kilometer',
                                number: platformFees,
                                unit: 'EGP',
                              ),

                              _buildDestinationInfoRow(
                                context,
                                icon: Icons.wallet_outlined,
                                title: 'Driver Earnings',
                                subtitle: 'Your final earnings',
                                number: driverEarning,
                                unit: 'EGP',
                                color: AppConstColors.approved,
                                highlighted: true,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
            const SizedBox(height: 24),
            _buildSectionTitle('Stop Points', Icons.location_on_rounded),

            ValueListenableBuilder<List<TextEditingController>>(
              valueListenable: pickupPoints,
              builder: (context, points, _) {
                return Column(
                  spacing: 12,
                  children: [
                    for (int index = 0; index < points.length; index++)
                      Row(
                        spacing: 12,
                        crossAxisAlignment: .center,
                        children: [
                          Column(
                            spacing: 2,
                            mainAxisAlignment: .end,
                            mainAxisSize: .max,
                            children: [
                              _pointIndicator(index + 1),
                              if (index != points.length - 1)
                                Container(
                                  height: 22,
                                  width: 2,
                                  color: AppConstColors.accent,
                                ),
                            ],
                          ),
                          Expanded(
                            child: AppTextFormField(
                              controller: points[index],
                              outLabel: ' ',
                              hintText: index == 0
                                  ? 'Starting point'
                                  : 'Pickup point',
                              inputAction: TextInputAction.next,
                              suffixIcon: points.length > 1
                                  ? IconButton(
                                      onPressed: () =>
                                          _removePickupPoint(index),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: AppConstColors.secondaryText,
                                        size: 22,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _addPickupPoint,
                        icon: const Icon(Icons.add_rounded, size: 22),
                        label: const Text('Add pickup point'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppConstColors.subSecondary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
            // CustomDivider(title: 'other data'),

            // Departure
            _buildSectionTitle('Departure', Icons.calendar_month_rounded),
            Row(
              children: [
                Expanded(
                  child: _buildSelectionField(
                    value: formattedDate,
                    icon: Icons.calendar_month_outlined,
                    onTap: _selectDate,
                    isSelected: departureDate != null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSelectionField(
                    value: formattedTime,
                    icon: Icons.access_time_rounded,
                    onTap: _selectTime,
                    isSelected: departureTime != null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Available Seats
            _buildSectionTitle('Available Seats', Icons.people_alt_rounded),
            ValueListenableBuilder(
              valueListenable: availableSeats,
              builder: (context, value, child) {
                return AppTextFormField(
                  isReadOnly: true,
                  // fontSize: 20,
                  // fontWeight: .w800,
                  textAlign: .center,
                  // isFilled: false,
                  controller: TextEditingController(
                    text:
                        "( ${value.toString()} ) ${value == 1 ? "Seat" : "Seats"}",
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (value > 1) {
                            availableSeats.value--;
                          }
                        },
                        icon: const Icon(
                          PhosphorIconsFill.minusCircle,
                          color: AppConstColors.subSecondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          availableSeats.value++;
                        },
                        icon: const Icon(
                          PhosphorIconsFill.plusCircle,
                          color: AppConstColors.subSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Additional Notes
            _buildSectionTitle('Additional Notes', Icons.notes_rounded),

            AppTextFormField(
              controller: notesController,
              hintText: 'Any additional notes? (Optional)...',
              keyboardType: TextInputType.multiline,
              inputAction: TextInputAction.newline,
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 24),

            // Create Ride
            ValueListenableBuilder(
              valueListenable: isRequiredFieldNotEmpty,
              builder: (context, value, child) {
                return AppMainButton(
                  onPressed: value
                      ? () {
                          // Ride creation logic will be added later.
                        }
                      : null,
                  // fontSize: 30,
                  isOutlined: !value,
                  mainColor: value ? null : AppConstColors.secondaryText,
                  btnHeight: 60,
                  title: 'Create Ride',
                  icon: Icons.arrow_forward_rounded,
                );
              },
            ),

            // // Cancel
            // AppMainButton(
            //   onPressed: () {},
            //   title: 'discard ?',
            //   isOutlined: true,
            //   mainColor: AppConstColors.error,
            //   // btnHeight: 44,
            // ),
          ],
        ),
      ),
    );
  }

  Container _showSearchLocationResults(
    BuildContext context, {
    required List<LocationModel> results,
    required isDestination,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * .3),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: AppConstColors.border,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
          top: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            results.length,
            (index) => Material(
              child: Column(
                mainAxisSize: .min,
                children: [
                  ListTile(
                    onTap: () => isDestination
                        ? _onDestinationSelected(results[index])
                        : _onDepartureSelected(results[index]),
                    leading: PhosphorIcon(
                      PhosphorIconsLight.mapPin,
                      color: AppConstColors.subSecondary,
                    ),
                    title: Text(results[index].address.toString()),
                  ),
                  if (index != results.length - 1)
                    Divider(
                      color: AppConstColors.secondary.withValues(alpha: .3),
                      thickness: .4,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required num number,
    required String unit,
    String? subtitle,
    Color? color,
    bool highlighted = false,
  }) {
    final itemColor = color ?? AppConstColors.primaryText;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: highlighted
          ? BoxDecoration(
              color: AppConstColors.approved.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: itemColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: itemColor, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600, color: itemColor),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppConstColors.secondaryText),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: number.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: itemColor),
                ),
                TextSpan(
                  text: ' $unit',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppConstColors.primaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Header content
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppConstColors.input,
                  fixedSize: const Size(32, 32),
                  side: const BorderSide(color: AppConstColors.border),
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppConstColors.primaryText,
                  size: 20,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Create New Ride',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppConstColors.primaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Plan your journey and share your ride.',
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppConstColors.secondaryText),
              ),
            ],
          ),
        ),

        // Illustration
        Expanded(
          flex: 2,
          child: Image.asset(AppConstImages.createNewRide, fit: BoxFit.contain),
        ),
      ],
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 6,
        children: [
          Icon(icon, color: AppConstColors.secondary, size: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: AppConstColors.secondary),
          ),
        ],
      ),
    );
  }

  // Date & Time Selection Field
  Widget _buildSelectionField({
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppConstColors.accent : AppConstColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppConstColors.accent
                  : AppConstColors.secondary,
              size: 18,
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                textAlign: .center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppConstColors.primaryText
                      : AppConstColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointIndicator(int number) {
    return CircleAvatar(
      // padding: .all(4),
      backgroundColor: AppConstColors.accent,
      radius: 12,
      // alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   border: Border.all(color: AppConstColors.secondary, width: 2),
      // ),
      child: Text(
        '$number',
        style: TextTheme.of(context).labelSmall!
            .copyWith(fontWeight: FontWeight.w600, color: AppConstColors.white),
      ),
    );
  }
}
