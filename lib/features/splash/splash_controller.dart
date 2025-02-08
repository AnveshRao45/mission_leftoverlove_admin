import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:mission_leftoverlove_admin/core/services/repositories/owner_repo.dart";
import "package:mission_leftoverlove_admin/core/services/repositories/splash_repo.dart";
import "package:mission_leftoverlove_admin/features/auth/auth_screen.dart";
import "package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart";
import "package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_screen.dart";
import "package:mission_leftoverlove_admin/route/navigation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

final splashRef = ChangeNotifierProvider(
  (ref) {
    final splashRepo = ref.read(splashRepoProvider);
    final ownerRepository = ref.read(ownerRepoProvider);
    return SplashController(splashRepo, ownerRepository);
  },
);

class SplashController with ChangeNotifier {
  final SplashRepo splashRepo;
  final OwnerRepo ownerRepo;

  SplashController(this.splashRepo, this.ownerRepo);

  Future<void> checkAndRedirect(WidgetRef ref) async {
    try {
      print("Splash Controller : Checking authentication state...");
      final getAuthState = splashRepo.getAuthState();

      if (getAuthState == AuthChangeEvent.signedIn) {
        print("Splash Controller : Owner is signed in. Fetching Owner ID...");
        final ownerId = ownerRepo.getOwnerId();
        print("Splash Controller : Owner ID fetched: $ownerId");
        final ownerModel = await ownerRepo.getOwnerData(ownerId);
        if (ownerModel != null) {
          print(
              "Splash Controller : Owner data fetched successfully. Updating global state...");
          ref.read(globalOwnerModel.notifier).state = ownerModel;

          print("splash controller: ${globalOwnerModel.notifier}");

          print("Splash Controller : Navigating to BottomNavScreen...");
          Navigation.instance.pushAndRemoveUntil(BottomNavScreen.id.path);
        } else {
          print(
              "Splash Controller : Failed to fetch Owner data. Redirecting to AuthScreen...");
          Navigation.instance.pushAndRemoveUntil(AuthScreen.id.path);
        }
      } else {
        print(
            "Splash Controller : Owner is not signed in. Redirecting to AuthScreen...");
        Navigation.instance.pushAndRemoveUntil(AuthScreen.id.path);
      }
    } catch (e) {
      print("Splash Controller : Error in checkAndRedirect: $e");
    }
  }
}
