import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/order_model.dart';
import 'package:mission_leftoverlove_admin/core/models/order_table_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/orders_repo.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';

// State class for OrdersController
class OrdersState {
  final List<OrderTable> orders;
  final bool isLoading;

  OrdersState({required this.orders, required this.isLoading});

  OrdersState copyWith({List<OrderTable>? orders, bool? isLoading}) {
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
    print("fetching restaurant id : $restaurantId");
    state = state.copyWith(isLoading: true);
    try {
      final orders =
          await _orderRepository.fetchOrdersByRestaurantId(restaurantId);
      // Ensure state is updated with a new instance
      state = state.copyWith(orders: [...orders], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

// Filter orders by status
  List<OrderTable> filterOrdersByStatus(String status) {
    return state.orders.where((order) => order.orderStat == status).toList();
  }

// Update or add a particular order in the list
  void addOrUpdateOrderRealtime(OrderTable order) {
    final existingIndex =
        state.orders.indexWhere((o) => o.orderId == order.orderId);

    List<OrderTable> updatedOrders = List.from(state.orders);

    if (existingIndex != -1) {
      updatedOrders[existingIndex] = order; // Update existing order
    } else {
      updatedOrders.add(order); // Add new order
    }

    state = state.copyWith(orders: updatedOrders); // Trigger state update
  }
}

final orderFutureProvider = FutureProvider.autoDispose.family<Order?, int>(
  (ref, orderId) async {
    final bookingRepo = ref.read(orderRepositoryProvider);
    final orderDetails = await bookingRepo.getOrderDetails(orderId);
    return orderDetails;
  },
);
final streamOrdersProvider = StateProvider<List<OrderTable>>(
  (ref) => [],
);

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
