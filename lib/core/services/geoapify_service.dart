import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_share/core/models/location_model.dart';

class GeoapifyService {
  static final String _apiKey = '4f784189ae224c2da006b43512f114d6';
  // static final String apiUrl =
  //     'https://api.geoapify.com/v1/geocode/autocomplete?text=Mosco&apiKey=4f784189ae224c2da006b43512f114d6';
  // static final response = http.get(apiUrl as Uri);
  Future<List<LocationModel>> searchLocation(String query) async {
    // avoid short query
    if (query.length < 2) {
      return [];
    }

    final uri = Uri.https('api.geoapify.com', '/v1/geocode/autocomplete', {
      'text': query,
      'apiKey': _apiKey,
      'format': 'json',
      'limit': '10',
      'filter': 'countrycode:eg',
      'lang': 'ar',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch locations');
    }

    final bodyJson = jsonDecode(response.body);

    final resultLocations = bodyJson['results'] as List;
    // print('Features count: ${resultLocations.length}');

    // if (resultLocations.isNotEmpty) {
    //   print(resultLocations.first);
    //   print(resultLocations.first['properties']);
    //   print(resultLocations.first['geometry']);
    // }

    final List<LocationModel> locations = [];
    for (var location in resultLocations) {
      locations.add(LocationModel.fromJson(location));
    }
    return locations;
  }

  Future<double> calculateDistanceInKm(
    LocationModel start,
    LocationModel destination,
  ) async {
    final uri = Uri.https('api.geoapify.com', '/v1/routing', {
      'waypoints':
          '${start.latitude},${start.longitude}|'
          '${destination.latitude},${destination.longitude}',
      'mode': 'drive',
      'format': 'json',
      'apiKey': _apiKey,
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to calculate distance');
    }

    final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;

    final results = bodyJson['results'] as List;

    if (results.isEmpty) {
      throw Exception('No route found');
    }

    final distanceMeters = (results.first['distance'] as num).toDouble();

    return distanceMeters / 1000;
  }

  Future<double> calculateTotalDistanceInKm(List<LocationModel> points) async {
    double totalDistance = 0;

    for (int i = 0; i < points.length - 1; i++) {
      final distance = await calculateDistanceInKm(points[i], points[i + 1]);

      totalDistance += distance;
    }

    return totalDistance;
  }
}
