import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/auth_repo.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_screen.dart';
import 'package:mission_leftoverlove_admin/route/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.read(authRepoProvider));
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepo _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  void _loadUser() async {
    print("[AuthController] Checking for existing logged-in user...");
    final user = _authRepository.currentUser;
    state = AsyncValue.data(user);
  }

  /// Sign up an owner
  Future<void> signUpOwner(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber}) async {
    try {
      state = const AsyncValue.loading();
      final emailExists = await _authRepository.checkOwnerEmailExists(email);
      if (emailExists) {
        throw Exception(
            "Email already in use. Please sign in with the credentials.");
      }

      print("[AuthController] Fetching an available restaurant for the owner");
      final restaurantId = await _authRepository.getAvailableRestaurant();
      if (restaurantId == null) {
        throw Exception("No available restaurants to assign.");
      }

      print(
          "[AuthController] Registering owner with restaurant ID: $restaurantId");
      final response = await _authRepository.signUpNewUser(email, password);
      if (response?.user == null) {
        throw Exception("Sign-up failed. No user returned.");
      }

      final user = response!.user!;
      await _authRepository.registerOwner(
          user.id, email, name, restaurantId, phoneNumber);
      print("[AuthController] Owner registration successful: ${user.id}");

      state = AsyncValue.data(user);
      Navigation.instance.pushAndRemoveUntil(BottomNavScreen.id.path);
    } catch (e, stackTrace) {
      print("[AuthController] Sign-up error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign in an existing owner
  Future<void> signInOwner(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      print("[AuthController] Signing in owner: $email");
      final response = await _authRepository.signInWithEmail(email, password);

      if (response?.user == null) {
        throw Exception("Sign-in failed. No user returned.");
      }

      print("[AuthController] Sign-in successful: ${response!.user!.id}");
      state = AsyncValue.data(response.user);
      await Navigation.instance.pushAndRemoveUntil(BottomNavScreen.id.path);
    } catch (e, stackTrace) {
      print("[AuthController] Sign-in error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign out the user
  Future<void> signOut() async {
    print("[AuthController] Logging out user...");
    await _authRepository.signOut();
    state = const AsyncValue.data(null);
    print("[AuthController] User logged out.");
  }
}

final authRepoProvider = Provider((ref) {
  final supabaseClient = ref.read(supabaseServiceProvider);
  return AuthRepo(supabaseClient);
});
