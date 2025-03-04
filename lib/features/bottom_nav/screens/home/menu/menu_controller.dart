import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/core/models/real_menu_model.dart';
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

  Future<bool> addMenuItem(RealMenuModel menuItem) async {
    return await menuRepository.addMenuItemToDB(menuItem);
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    return await menuRepository.fetchCategories();
  }

  Future<List<Map<String, dynamic>>> fetchSubcategories(int categoryId) async {
    return await menuRepository.fetchSubcategories(categoryId);
  }

  /// Update a food item. You may also update your local state if needed.
  Future<bool> updateFoodItem(RealMenuModel menuItem) async {
    final success = await menuRepository.updateMenuItem(menuItem);
    // Optionally update the local state here if you cache your list of menu items.
    return success;
  }

  Future<RealMenuModel?> getRealMenuItemById(int menuId) async {
    final success = await menuRepository.getMenuById(menuId);
    return success;
  }
}
