import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/location_model.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/core/models/restaurent_model.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:mission_leftoverlove_admin/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final restaurenRepoProvider = Provider(
  (ref) {
    final supabaseClient = ref.watch(supabaseServiceProvider);
    return RestaurentRepo(supabaseClient);
  },
);

class RestaurentRepo {
  final SupabaseClient _supabaseClient;

  RestaurentRepo(this._supabaseClient);

  Future<List<MenuModel>> getMenuOfRestaurent(int restaurentId) async {
    final restaurentMenu = await _supabaseClient
        .rpc(
          "getrestaurentmenunow",
          params: {'res_id': restaurentId},
          get: true,
        )
        .select();

    debugLog("RESTAURANT REPO","Raw RPC Response: ${restaurentMenu.toString()}");

    debugLog("RESTAURANT REPO", restaurentId.toString());
    final menuList = parseMenuList(restaurentMenu);

    debugLog("RESTAURANT REPO",menuList.toString());

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

  Future<Map<int, RestaurentModel>> getAllRestaurentsRealtime(
      LocationModel locationmodel) async {
    try {
      // Call the 'nearby_restaurants' function with lat and long parameters
      final restaurentsMapList = await _supabaseClient.rpc('nearby_restaurants',
          params: {'lat': locationmodel.lat, 'long': locationmodel.lng});

      // Log the response for debugging
      // debugLog("RESTAURANT REPO",'Response from nearby_restaurants: $restaurentsMapList');

      // Parse the map and update the state
      final restaurentsMap = parseRestaurentMap(restaurentsMapList);

      return restaurentsMap;
    } catch (e) {
      // Log any error that occurs
      debugLog("RESTAURANT REPO",'Error calling nearby_restaurants: $e');
      return {};
    }
  }
}
