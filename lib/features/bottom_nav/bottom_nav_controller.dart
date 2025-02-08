import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/owner_model.dart';
import 'package:mission_leftoverlove_admin/core/models/restaurent_model.dart';
import 'package:mission_leftoverlove_admin/core/models/user_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/restaurent_repo.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final bottomNavRef = ChangeNotifierProvider(
  (ref) {
    final supabase = ref.read(supabaseServiceProvider);
    return BottomNavController(supabase);
  },
);

final globalUserModel = StateProvider<UserModel?>(
  (ref) => null,
);

final globalOwnerModel = StateProvider<OwnerModel?>(
  (ref) => null,
);

final carouselPage = StateProvider<int>(
  (ref) => 0,
);

final categoriesFutureProvider = FutureProvider<List<String>>(
  (ref) async {
    final restaurantRepo = ref.read(restaurenRepoProvider);
    final allCategories = await restaurantRepo.getAllCategories();
    return allCategories;
  },
);

final loadingStateProvider = StateProvider<bool>((ref) => false);

final restaurents = StateProvider<Map<int, RestaurentModel>>(
  (ref) => {},
);

class BottomNavController with ChangeNotifier {
  final SupabaseClient _client;

  BottomNavController(this._client);

  realtime() async {
    _client
        .channel(restaurentTableName)
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: restaurentTableName,
          callback: (payload) {
            // final updatedRestaurent =
            //     RestaurentModel.fromJson(payload.newRecord);
            // _restaurentsMap[updatedRestaurent.restaurantId!] =
            //     updatedRestaurent;
          },
        )
        .subscribe();
  }

  List<RestaurentModel> getFilteredRestaurants(
    List<RestaurentModel> restaurants,
    List<String> selectedCategories,
  ) {
    // If no categories are selected, return all restaurants
    if (selectedCategories.isEmpty) {
      return restaurants;
    }

    // Filter restaurants based on selected categories
    return restaurants.where(
      (restaurant) {
        return selectedCategories.any(
          (category) => restaurant.elgibleCategory!.contains(category),
        );
      },
    ).toList();
  }
}
