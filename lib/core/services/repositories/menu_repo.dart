import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/core/models/real_menu_model.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final menuRepoProvider = Provider(
  (ref) {
    final supabaseClient = ref.watch(supabaseServiceProvider);
    return MenuRepo(supabaseClient);
  },
);

class MenuRepo {
  final SupabaseClient _supabaseClient;

  MenuRepo(this._supabaseClient);

  Future<List<MenuModel>> getMenuOfRestaurant(int restaurentId) async {
    final restaurentMenu = await _supabaseClient
        .rpc(
          "getrestaurentmenunow",
          params: {'res_id': restaurentId},
          get: true,
        )
        .select();

    print("Raw RPC Response: ${restaurentMenu.toString()}");

    print(restaurentId.toString());
    final menuList = parseMenuList(restaurentMenu);

    print(menuList.toString());

    return menuList;
  }

  Future<List<String>> getAllCategories() async {
    try {
      final response = await _supabaseClient.from(categoryTableName).select(
          'category_name'); // Assuming 'category_name' is the field in your table

      List<String> categoryNames = response
          .map((category) => category['category_name'] as String)
          .toList();

      return categoryNames;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> addMenuItemToDB(RealMenuModel menuItem) async {
    try {
      final data = menuItem.toJson();
      print("Data being inserted: $data"); // 👀 Debugging

      final response = await _supabaseClient.from('menu').insert(data);

      if (response.error != null) {
        print('Error adding food item: ${response.error!.message}');
        return false;
      }
      return true;
    } catch (e) {
      print('Exception adding food item: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response =
        await _supabaseClient.from('category').select('id, category_name');

    if (response.isEmpty) {
      return [];
    }

    return response
        .map((cat) => {
              'id': cat['id'],
              'name': cat['category_name'],
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchSubcategories(int categoryId) async {
    final response = await _supabaseClient
        .from('subcategory')
        .select('id, subcategory_name')
        .eq('category_id', categoryId);

    if (response.isEmpty) {
      return [];
    }

    return response
        .map((sub) => {
              'id': sub['id'],
              'name': sub['subcategory_name'],
            })
        .toList();
  }

  Future<bool> updateMenuItem(RealMenuModel model) async {
    // Ensure the primary key (menuId) is not null
    if (model.menuId == null) {
      print("menuId is null, cannot update");
      return false;
    }

    try {
      final response = await _supabaseClient
          .from('menu')
          .update({
            'restaurant_id': model.restaurantId,
            'item_name': model.itemName,
            'description': model.description,
            'price': model.price,
            'is_veg': model.isVeg,
            'actual_price': model.actualPrice,
            'image': model.image,
            'quantity': model.quantity,
            'cuisuine': model.cuisine,
            'category_id': model.categoryId,
            'subcategory_id': model.subcategoryId,
            'is_active': model.isActive,
          })
          .eq('menu_id', model.menuId!)
          .select()
          .maybeSingle();

      if (response == null) {
        print("Null response received from update query");
        return false;
      }
      print("Update successful, response data: $response");
      return true;
    } catch (e) {
      print("Exception while updating menu: $e");
      return false;
    }
  }

  Future<RealMenuModel?> getMenuById(int menuId) async {
    final response = await _supabaseClient
        .from('menu')
        .select()
        .eq('menu_id', menuId)
        .maybeSingle();

    final data = response;

    print(data);
    return RealMenuModel.fromJson(data as Map<String, dynamic>);
  }
}
