import 'package:ride_share/core/models/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverServices {
  static final SupabaseClient supabaseClient = Supabase.instance.client;
  static final userId = supabaseClient.auth.currentUser?.id;

  static Future<bool> checkIsUserAsDriver(String userId) async {
    return false;
  }
static Future<void> createRequest({
  required String userId,
  required String idCardUrl,
  required String criminalRecordUrl,
  required String drivingLicenseUrl,
  required String carType,
  required String carModel,
  required String carColor,
  required String licensePlate,
  List<String>? carImagesUrl,
}) async {
  await supabaseClient.from('drivers').insert({
    'user_id': userId,
    'id_card_url': idCardUrl,
    'criminal_record_url': criminalRecordUrl,
    'driving_license_url': drivingLicenseUrl,
    'car_type': carType,
    'car_model': carModel,
    'car_color': carColor,
    'license_plate': licensePlate,
    'car_images': carImagesUrl,
  });
}

  static Future<void> deleteRequest(DriverModel driverModel) async {}
  static Future<void> cehckRequestStatus(DriverModel driverModel) async {}
}
