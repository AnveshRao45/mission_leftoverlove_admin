import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/order_details_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/orders_repo.dart';
import 'package:mission_leftoverlove_admin/features/orders/orders_controller.dart';

class OrderDetailsController
    extends StateNotifier<AsyncValue<List<OrderDetail>>> {
  final OrderRepository _orderRepository;

  OrderDetailsController(this._orderRepository)
      : super(const AsyncValue.loading());

  // Fetch order details
  Future<void> fetchOrderDetails(int orderId) async {
    state = const AsyncValue.loading(); // Set state to loading
    try {
      final orderDetails =
          await _orderRepository.fetchOrderDetailsByOrderId(orderId);
      state = AsyncValue.data(orderDetails); // Set state to data
    } catch (e, stackTrace) {
      print('Error fetching order details: $e'); // Debug the error
      state = AsyncValue.error(e, stackTrace); // Set state to error
    }
  }
}

// Provider for OrderDetailsController
final orderDetailsProvider = StateNotifierProvider.family<
    OrderDetailsController, AsyncValue<List<OrderDetail>>, int>(
  (ref, orderId) {
    final orderRepository = ref.watch(orderRepositoryProvider);
    final controller = OrderDetailsController(orderRepository);
    controller
        .fetchOrderDetails(orderId);
    return controller;
  },
);
