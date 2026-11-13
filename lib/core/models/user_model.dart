import 'package:ride_share/core/providers/auth_provider.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePictureUrl,
    this.phone,
    this.currentMode = UserMode.rider,
    required this.createdAt,
  });

  final String id;
  String fullName;
  final String email;
  String? profilePictureUrl;
  String? phone;
  final UserMode currentMode;
  final DateTime createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      profilePictureUrl: json['profile_photo_url'],
      phone: json['phone'],
      currentMode: UserMode.rider,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
