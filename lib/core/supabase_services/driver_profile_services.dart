import 'package:ride_share/core/extension/driver_approval_status_extension.dart';
import 'package:ride_share/core/models/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverProfileServices {
  static final SupabaseClient supabaseClient = Supabase.instance.client;
  static final userId = supabaseClient.auth.currentUser!.id;

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
    List<String>? carImagesUrls,
  }) async {
    await supabaseClient.from('driver_profiles').insert({
      'user_id': userId,
      'id_card_url': idCardUrl,
      'criminal_record_url': criminalRecordUrl,
      'driving_license_url': drivingLicenseUrl,
      'car_type': carType,
      'car_model': carModel,
      'car_color': carColor,
      'license_plate': licensePlate,
      'car_images': carImagesUrls,
    });
  }

  // static Future<void> updateDriverImages({
  //   required String userId,
  //   required String idCardUrl,
  //   required String criminalRecordUrl,
  //   required String drivingLicenseUrl,
  //   List<String>? carImages,
  // }) async {
  //   await supabaseClient
  //       .from('driver_profiles')
  //       .update({
  //         'id_card_url': idCardUrl,
  //         'criminal_record_url': criminalRecordUrl,
  //         'driving_license_url': drivingLicenseUrl,
  //         'car_images': carImages,
  //       })
  //       .eq('user_id', userId);
  // }

  static Future<void> deleteRequest() async {
    //delete the row in table
    await supabaseClient.from('driver_profiles').delete().eq('user_id', userId);

    //delete documents (3 images) from driver-documents bucket
    final driverDocuments = await supabaseClient.storage
        .from('driver-documents')
        .list(path: userId);
    if (driverDocuments.isNotEmpty) {
      final documentPaths = driverDocuments
          .map((file) => '$userId/${file.name}')
          .toList();
      await supabaseClient.storage
          .from('driver-documents')
          .remove(documentPaths);
    }

    //delete car images from car-images bucket

    final carImages = await supabaseClient.storage
        .from('car-images')
        .list(path: userId);
    if (carImages.isNotEmpty) {
      final imagePaths = carImages
          .map((file) => '$userId/${file.name}')
          .toList();
      await supabaseClient.storage.from('car-images').remove(imagePaths);
    }
  }

  static Future<DriverProfileModel?> loadDriverProfileData() async {
    final response = await supabaseClient
        .from('driver_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }
    return DriverProfileModel.fromJson(response);
  }

  static Future<DriverApprovalStatus> getDriverApprovalStatus() async {
    final driverProfileStatus = await supabaseClient
        .from('driver_profiles')
        .select('approval_status')
        .eq('user_id', userId)
        .maybeSingle();
    if (driverProfileStatus == null) {
      return DriverApprovalStatus.underReview;
    }

    return DriverApprovalStatusX.fromDb(
      driverProfileStatus['approval_status'] as String,
    );
  }

  static Future<bool> isUserHasDriverProfile() async {
    final driverProfile = await supabaseClient
        .from('driver_profiles')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();
    //  final bool isDriverProfileExists = driverProfile != null && driverProfile['user_id']
    return driverProfile != null;
  }
}
