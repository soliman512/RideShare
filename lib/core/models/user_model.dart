import 'package:ride_share/core/providers/auth_provider.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.currentMode = UserMode.rider,
    required this.createdAt,
  });

  final String id;
  String fullName;
  final String email;
  String? phone;
  final UserMode currentMode;
  final DateTime createdAt;
}
