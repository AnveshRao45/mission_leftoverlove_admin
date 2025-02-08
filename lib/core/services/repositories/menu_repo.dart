import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
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
}
