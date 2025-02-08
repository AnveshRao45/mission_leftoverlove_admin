import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/menu_repo.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';

final menuControllerProvider =
    StateNotifierProvider<MenuController, List<MenuModel>>((ref) {
  final menuRepo = ref.watch(menuRepoProvider);
  final globalOwnerRepo = ref.watch(globalOwnerModel);
  return MenuController(
      menuRepository: menuRepo, restaurantId: globalOwnerRepo!.restaurantId);
});

class MenuController extends StateNotifier<List<MenuModel>> {
  final MenuRepo menuRepository;
  final int? restaurantId;

  MenuController({required this.menuRepository, required this.restaurantId})
      : super([]) {
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      final menuItems = await menuRepository.getMenuOfRestaurant(restaurantId!);
      state = menuItems;
    } catch (e) {
      print("Error fetching menu: $e");
    }
  }
}
