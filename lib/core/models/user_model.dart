import 'package:ride_share/core/providers/auth_provider.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.currentMode = UserMode.rider,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final UserMode currentMode;
  final DateTime createdAt;
}
