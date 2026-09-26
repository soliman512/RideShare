
import 'package:rider_share/core/constants/app_constants.dart';
import 'package:rider_share/core/models/ride_model.dart';
import 'package:flutter/material.dart';
class RideStatusFilterChip extends StatelessWidget {
  const RideStatusFilterChip({
    super.key,
    required this.status,
    required this.icon,
    required this.selectedStatus,
    required this.onSelected,
  });

  final RideStatus status;
  final IconData icon;
  final RideStatus? selectedStatus;
  final ValueChanged<RideStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedStatus == status;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected
            ? AppConstColors.secondary
            : AppConstColors.secondaryText,
      ),
      label: Text(status.name),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: AppConstColors.subSecondary.withValues(alpha: .2),
      backgroundColor: AppConstColors.surface,
      side: BorderSide(
        color: isSelected
            ? AppConstColors.subSecondary
            : AppConstColors.secondaryText,
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? AppConstColors.secondary
            : AppConstColors.secondaryText,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      onSelected: (_) => onSelected(status),
    );
  }
}

