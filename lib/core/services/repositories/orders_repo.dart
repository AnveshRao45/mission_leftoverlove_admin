import 'package:mission_leftoverlove_admin/core/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient supabase;

  OrderRepository(this.supabase);

  // Fetch orders for a specific restaurant
  Future<List<Order>> fetchOrdersByRestaurantId(int restaurantId) async {
    try {
      final response = await supabase
          .from('orders') // Ensure the table name is correct
          .select()
          .eq('restaurent_id',
              restaurantId) // Ensure the column name is correct
          .select();

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
