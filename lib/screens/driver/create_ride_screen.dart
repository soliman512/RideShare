
import 'package:flutter/material.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';
import 'package:ride_share/core/widgets/app_text_form_field.dart';
import 'package:ride_share/core/widgets/app_button.dart';  
class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  // Controllers
  final TextEditingController destinationController =
      TextEditingController();

  final TextEditingController notesController =
      TextEditingController();

  final List<TextEditingController> pickupControllers = [
    TextEditingController(),
  ];

  // Departure information
  DateTime? departureDate;
  TimeOfDay? departureTime;

  // Seats
  int totalSeats = 3;

  @override
  void dispose() {
    destinationController.dispose();
    notesController.dispose();

    for (final controller in pickupControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Date Picker
  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (selectedDate != null) {
      setState(() {
        departureDate = selectedDate;
      });
    }
  }

  // Time Picker
  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: departureTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        departureTime = selectedTime;
      });
    }
  }

  // Add Pickup Point
  void _addPickupPoint() {
    setState(() {
      pickupControllers.add(TextEditingController());
    });
  }

  // Remove Pickup Point
  void _removePickupPoint(int index) {
    setState(() {
      final controller = pickupControllers.removeAt(index);
      controller.dispose();
    });
  }

  // Date Formatting
  String get formattedDate {
    if (departureDate == null) return 'Select departure date';

    final date = departureDate!;

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Time Formatting
  String get formattedTime {
    if (departureTime == null) return 'Select departure time';

    return departureTime!.format(context);
  }

  // Combine Date & Time
  DateTime? get departureDateTime {
    if (departureDate == null || departureTime == null) {
      return null;
    }

    return DateTime(
      departureDate!.year,
      departureDate!.month,
      departureDate!.day,
      departureTime!.hour,
      departureTime!.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppConstColors.secondary.withValues(
                          alpha: .12,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.add_road_rounded,
                        size: 38,
                        color: AppConstColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Create a Ride',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppConstColors.subSecondary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Plan your journey and share your ride.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                            color: AppConstColors.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Destination Section
              _buildSectionTitle(
                'Journey Details',
                Icons.route_rounded,
              ),

              const SizedBox(height: 16),

              AppTextFormField(
                controller: destinationController,
                outLabel: 'Destination',
                hintText: 'Where are you going?',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppConstColors.secondary,
                ),
                inputAction: TextInputAction.next,
              ),

              const SizedBox(height: 22),

              // Departure Section
              _buildSectionTitle(
                'Departure Information',
                Icons.schedule_rounded,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildSelectionField(
                      label: 'Departure Date',
                      value: formattedDate,
                      icon: Icons.calendar_month_rounded,
                      onTap: _selectDate,
                      isSelected: departureDate != null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectionField(
                      label: 'Departure Time',
                      value: formattedTime,
                      icon: Icons.access_time_rounded,
                      onTap: _selectTime,
                      isSelected: departureTime != null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Seats Section
              _buildSectionTitle(
                'Available Seats',
                Icons.event_seat_rounded,
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppConstColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.blueGrey.withValues(alpha: .3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      color: AppConstColors.secondary,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Number of seats',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppConstColors.subSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            'Available passenger seats',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: AppConstColors.secondaryText,
                                ),
                          ),
                        ],
                      ),
                    ),
                    _buildCounterButton(
                      icon: Icons.remove_rounded,
                      onTap: totalSeats > 1
                          ? () {
                              setState(() {
                                totalSeats--;
                              });
                            }
                          : null,
                    ),
                    SizedBox(
                      width: 42,
                      child: Text(
                        '$totalSeats',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppConstColors.subSecondary,
                            ),
                      ),
                    ),
                    _buildCounterButton(
                      icon: Icons.add_rounded,
                      onTap: totalSeats < 7
                          ? () {
                              setState(() {
                                totalSeats++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Pickup Points Section
              Row(
                children: [
                  Expanded(
                    child: _buildSectionTitle(
                      'Pickup Points',
                      Icons.pin_drop_outlined,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addPickupPoint,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Add Stop'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppConstColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...List.generate(
                pickupControllers.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: AppTextFormField(
                    controller: pickupControllers[index],
                    outLabel: 'Pickup Point ${index + 1}',
                    hintText: 'Enter pickup location',
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppConstColors.secondary,
                    ),
                    suffixIcon: pickupControllers.length > 1
                        ? IconButton(
                            onPressed: () => _removePickupPoint(index),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          )
                        : null,
                    inputAction: TextInputAction.next,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Notes Section
              _buildSectionTitle(
                'Additional Notes',
                Icons.notes_rounded,
              ),

              const SizedBox(height: 16),

              AppTextFormField(
                controller: notesController,
                outLabel: 'Notes (Optional)',
                hintText: 'Add details about your ride...',
                keyboardType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
              ),

              const SizedBox(height: 32),

              // Create Ride Button
              AppMainButton(
                onPressed: () {
                  // Ride creation logic will be added later.
                },
                title: 'Create Ride',
                icon: Icons.arrow_forward_rounded,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppConstColors.secondary,
          size: 21,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppConstColors.subSecondary,
              ),
        ),
      ],
    );
  }

  // Date & Time Selection Field
  Widget _buildSelectionField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: AppConstColors.secondary,
                ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppConstColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blueGrey.withValues(alpha: .4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppConstColors.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isSelected
                              ? AppConstColors.subSecondary
                              : AppConstColors.secondaryText,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Seats Counter Button
  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppConstColors.secondary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 19,
          color: onTap == null
              ? AppConstColors.secondaryText
              : AppConstColors.secondary,
        ),
      ),
    );
  }
}
