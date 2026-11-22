import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/constants/app_const_images.dart';
import 'package:ride_share/core/extension/screen_size_extension.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/app_button.dart';
import 'package:ride_share/core/widgets/custom_divider.dart';
import 'package:ride_share/screens/app_scaffold.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final ValueNotifier<int> availableSeats = ValueNotifier<int>(3);

  final ValueNotifier<List<TextEditingController>> pickupPoints = ValueNotifier(
    [TextEditingController()],
  );

  DateTime? departureDate;
  TimeOfDay? departureTime;

  int totalSeats = 3;

  @override
  void dispose() {
    destinationController.dispose();
    notesController.dispose();
    availableSeats.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 36),
            // Form Content
            _buildSectionTitle('Destination', Icons.location_on_rounded),

            AppTextFormField(
              controller: destinationController,
              hintText: 'Enter destination',
              // suffixIcon: IconButton(
              //   onPressed: () {
              //     // Open destination map picker.
              //   },
              //   icon: const Icon(Icons.map_outlined, color: Color(0xff536D9F)),
              // ),
              inputAction: TextInputAction.next,
            ),
            // Pickup Points

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
                              _PointIndicator(number: index + 1),
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
                      alignment: Alignment.center,
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
                  fontSize: 20,
                  fontWeight: .w800,
                  textAlign: .center,
                  // isFilled: false,
                  controller: TextEditingController(text: value.toString()),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (value > 1) {
                            availableSeats.value--;
                          }
                        },
                        icon: const Icon(PhosphorIconsFill.minusCircle),
                      ),
                      IconButton(
                        onPressed: () {
                          availableSeats.value++;
                        },
                        icon: const Icon(PhosphorIconsFill.plusCircle),
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
            AppMainButton(
              onPressed: () {
                // Ride creation logic will be added later.
              },
              title: 'Create Ride',
              icon: Icons.arrow_forward_rounded,
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
}

class _PointIndicator extends StatelessWidget {
  const _PointIndicator({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
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
