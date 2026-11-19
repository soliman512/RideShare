
import 'package:ride_share/core/services/image_compress_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverStorageService {
  static final supabaseClient = Supabase.instance.client;

  static Future<String> _uploadImage({
    required String bucket,
    required String filePath,
    required String storagePath,
  }) async {
    final imageBytes =
        await ImageCompressionService.compressToWebp(filePath);

    await supabaseClient.storage.from(bucket).uploadBinary(
      storagePath,
      imageBytes,
      fileOptions: const FileOptions(
        contentType: 'image/webp',
        upsert: true,
      ),
    );

    return storagePath;
  }

  static Future<Map<String, dynamic>> uploadDriverImages({
    required String userId,
    required String idCardPath,
    required String criminalRecordPath,
    required String drivingLicensePath,
    List<String>? carImagePaths,
  }) async {
    // Upload driver documents
    final documentPaths = await Future.wait<String>([
      _uploadImage(
        bucket: 'driver-documents',
        filePath: idCardPath,
        storagePath: '$userId/id_card.webp',
      ),
      _uploadImage(
        bucket: 'driver-documents',
        filePath: criminalRecordPath,
        storagePath: '$userId/criminal_record.webp',
      ),
      _uploadImage(
        bucket: 'driver-documents',
        filePath: drivingLicensePath,
        storagePath: '$userId/driving_license.webp',
      ),
    ]);

    // Upload car images
    final uploadedCarImages = carImagePaths == null
        ? null
        : await Future.wait<String>(
            carImagePaths.asMap().entries.map((entry) {
              final index = entry.key;
              final imagePath = entry.value;

              return _uploadImage(
                bucket: 'car-images',
                filePath: imagePath,
                storagePath:
                    '$userId/${DateTime.now().microsecondsSinceEpoch}_$index.webp',
              );
            }),
          );

    return {
      'id_card_url': documentPaths[0],
      'criminal_record_url': documentPaths[1],
      'driving_license_url': documentPaths[2],
      'car_images': uploadedCarImages,
    };
  }
}
