import 'package:mission_leftoverlove_admin/core/models/order_details_model.dart';
import 'package:mission_leftoverlove_admin/core/models/order_model.dart';
import 'package:mission_leftoverlove_admin/core/models/order_table_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient supabase;

  OrderRepository(this.supabase);

  // Fetch orders for a specific restaurant
  Future<List<OrderTable>> fetchOrdersByRestaurantId(int restaurantId) async {
    try {
      final response = await supabase
          .from('orders') // Ensure the table name is correct
          .select()
          .eq('restaurant_id',
              restaurantId) // Ensure the column name is correct
          .select();

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => OrderTable.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<List<OrderDetail>> fetchOrderDetailsByOrderId(int orderId) async {
    try {
      final response =
          await supabase.from('order_details').select().eq('order_id', orderId);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => OrderDetail.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch order details: $e');
    }
  }

  Future<Order?> getOrderDetails(int orderUid) async {
    try {
      final orderRes = await supabase
          .rpc("get_order_details", params: {"order_uid": orderUid});
      final order = Order.fromJson(orderRes);

      return order;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
