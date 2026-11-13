import 'package:ride_share/core/models/user_model.dart';
import 'package:ride_share/core/services/image_compress_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  //supabase client instance
  static final SupabaseClient supabaseClient = Supabase.instance.client;
  // send otp
  static Future<void> signInWithEmailOtp(String email) async {
    await supabaseClient.auth.signInWithOtp(email: email);
  }

  //verify otp
  static Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    return await supabaseClient.auth.verifyOTP(
      email: email.trim(),
      token: token.trim(),
      type: OtpType.email,
    );
  }

  //insert user to public.users table
  static Future<void> createUserProfile({
    required String fullName,
    String? phone,
    String? profilePictureUrl,
  }) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await supabaseClient.from('users').insert({
      'id': user.id,
      'full_name': fullName,
      'email': user.email,
      'phone': phone,
      'profile_photo_url': profilePictureUrl,
      'rating': 0.0,
      'total_reviews': 0,
    });
  }

  // update user in auth.users table
  static Future<void> updateAuthUser({
    required String fullName,
    String? phone,
  }) async {
    await supabaseClient.auth.updateUser(
      UserAttributes(data: {'full_name': fullName, 'phone': phone}),
    );
  }

  // upload profile picture
  static Future<String> uploadProfilePicture({
    required String userId,
    required String imagePath,
  }) async {
    final imageBytes = await ImageCompressionService.compressToWebp(imagePath);

    final filePath = '$userId/avatar.webp';

    await Supabase.instance.client.storage
        .from('profile-pictures')
        .uploadBinary(
          filePath,
          imageBytes,
          fileOptions: const FileOptions(
            contentType: 'image/webp',
            upsert: true,
            cacheControl: '3600',
          ),
        );

    return Supabase.instance.client.storage
        .from('profile-pictures')
        .getPublicUrl(filePath);
  }

  // check if user in public.users or no
  static Future<bool> isUserProfileExists() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final profile = await supabaseClient
        .from('users')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    return profile != null;
  }

  // check user session
  static bool isUserHasSession() {
    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      return false;
    }
    //get user data and save in usermodel in provider

    return true;
  }

  //get user data
  static Future<UserModel?> getCurrentUserData() async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await supabaseClient
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserModel.fromJson(response);
  }

  //update user data
  static Future<void> updateUserData({
    required String userId,
    required String fullName,
    required String phone,
  }) async {
    await supabaseClient
        .from('users')
        .update({
          'full_name': fullName,
          'phone': phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }
}
