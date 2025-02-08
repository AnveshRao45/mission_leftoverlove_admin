import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/order_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/orders_repo.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';

// State class for OrdersController
class OrdersState {
  final List<Order> orders;
  final bool isLoading;

  OrdersState({required this.orders, required this.isLoading});

  OrdersState copyWith({List<Order>? orders, bool? isLoading}) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// StateNotifier for OrdersController
class OrdersController extends StateNotifier<OrdersState> {
  final OrderRepository _orderRepository;

  OrdersController(this._orderRepository)
      : super(OrdersState(orders: [], isLoading: false));

  // Fetch orders for a specific restaurant
  Future<void> fetchOrders(int restaurantId) async {
    state = state.copyWith(isLoading: true);
    try {
      final orders =
          await _orderRepository.fetchOrdersByRestaurantId(restaurantId);
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // Filter orders by status
  List<Order> filterOrdersByStatus(String status) {
    return state.orders.where((order) => order.orderStat == status).toList();
  }
}

// Provider for OrdersController
final ordersControllerProvider =
    StateNotifierProvider<OrdersController, OrdersState>(
  (ref) {
    final orderRepository = ref.watch(orderRepositoryProvider);
    return OrdersController(orderRepository);
  },
);

// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) {
    final supabase = ref.watch(supabaseServiceProvider);
    return OrderRepository(supabase);
  },
);
