import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  final SupabaseClient supabaseClient;

  AuthRepo(this.supabaseClient);

  /// Checks if the owner email already exists
  Future<bool> checkOwnerEmailExists(String email) async {
    try {
      print("[AuthRepo] Checking if email exists: $email");
      final existingOwner = await supabaseClient
          .from('owners')
          .select('owner_id')
          .eq('email', email)
          .maybeSingle();

      return existingOwner != null;
    } catch (e) {
      print("[AuthRepo] Error checking email existence: $e");
      return false;
    }
  }

  /// Fetches an available restaurant for a new owner
  Future<int?> getAvailableRestaurant() async {
    try {
      print("[AuthRepo] Fetching an available restaurant...");
      final restaurant = await supabaseClient
          .from('restaurents')
          .select('restaurant_id')
          .order('restaurant_id', ascending: true)
          .limit(1)
          .maybeSingle();

      return restaurant?['restaurant_id'];
    } catch (e) {
      print("[AuthRepo] Error fetching available restaurant: $e");
      return null;
    }
  }

  /// Registers a new owner in the database
  Future<void> registerOwner(String ownerId, String email, String name,
      int restaurantId, String phoneNumber) async {
    try {
      print(
          "[AuthRepo] Registering owner $ownerId for restaurant ID: $restaurantId");
      await supabaseClient.from('owners').insert({
        'owner_id': ownerId,
        'email': email,
        'name': name,
        'restaurant_id': restaurantId,
        'phone_number': phoneNumber,
      });

      // // Update the restaurant with the assigned owner
      // await supabaseClient
      //     .from('restaurents')
      //     .update({'owner_id': ownerId}).eq('restaurant_id', restaurantId);

      print("[AuthRepo] Owner registered successfully.");
    } catch (e) {
      print("[AuthRepo] Error registering owner: $e");
      throw Exception("Failed to register owner.");
    }
  }

  /// Registers a new user in Supabase authentication
  Future<AuthResponse?> signUpNewUser(String email, String password) async {
    try {
      print("[AuthRepo] Signing up new user: $email");
      final response =
          await supabaseClient.auth.signUp(email: email, password: password);

      if (response.user == null) {
        throw Exception("Sign-up failed: No user returned.");
      }

      print("[AuthRepo] Sign-up successful: ${response.user!.id}");
      return response;
    } catch (e) {
      print("[AuthRepo] Sign-up failed: $e");
      return null;
    }
  }

  /// Signs in a user
  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    try {
      print("[AuthRepo] Signing in user: $email");
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw Exception("Sign-in failed: No user returned.");
      }

      print("[AuthRepo] Sign-in successful: ${response.user!.id}");
      return response;
    } catch (e) {
      print("[AuthRepo] Sign-in failed: $e");
      return null;
    }
  }

  /// Logs out the user
  Future<void> signOut() async {
    try {
      print("[AuthRepo] Logging out user...");
      await supabaseClient.auth.signOut();
      print("[AuthRepo] User logged out.");
    } catch (e) {
      print("[AuthRepo] Sign-out failed: $e");
    }
  }

  /// Retrieves the currently logged-in user
  User? get currentUser {
    final user = supabaseClient.auth.currentUser;
    print("[AuthRepo] Checking current user: ${user?.id}");
    return user;
  }
}
