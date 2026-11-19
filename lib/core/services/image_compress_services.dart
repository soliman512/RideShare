import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressionService {
  static const int maxSizeBytes = 300 * 1024;

  static Future<Uint8List> compressToWebp(String imagePath) async {
    const dimensions = [512, 384, 256];
    const qualities = [85, 75, 65, 55, 45];

    for (final dimension in dimensions) {
      for (final quality in qualities) {
        final result = await FlutterImageCompress.compressWithFile(
          imagePath,
          format: CompressFormat.webp,
          quality: quality,
          minWidth: dimension,
          minHeight: dimension,
        );

        if (result == null || result.isEmpty) {
          throw Exception('Image compression failed');
        }

        if (result.lengthInBytes <= maxSizeBytes) {
          return result;
        }
      }
    }

    throw Exception('Image exceeds the allowed size');
  }
}
