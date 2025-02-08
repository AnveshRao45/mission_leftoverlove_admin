import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/owner_repo.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final splashRepoProvider = Provider((ref) {
  final supabaseProvider = ref.read(supabaseServiceProvider);
  final ownerRepo = ref.read(ownerRepoProvider);
  // final auth = FirebaseAuth.instance;
  return SplashRepo(supabaseProvider, ownerRepo);
});

class SplashRepo {
  final SupabaseClient supabaseClient;
  // final FirebaseAuth firebaseAuth;
  final OwnerRepo ownerRepo;

  SplashRepo(
    this.supabaseClient,
    this.ownerRepo,
  );

  AuthChangeEvent getAuthState() {
    final authState = supabaseClient.auth.currentUser;
    if (authState != null) {
      return AuthChangeEvent.signedIn;
    } else {
      return AuthChangeEvent.signedOut;
    }
    // return authState.event;
  }
}
