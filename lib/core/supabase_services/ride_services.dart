
import 'package:ride_share/core/models/ride_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RideServices {
  static final supabaseClient = Supabase.instance.client;

  static Future<String> createNewRideAndGetRideId(RideModel ridemodel)async{
    return '';
  }
}