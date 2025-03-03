import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/order_item_card.dart';
import 'package:mission_leftoverlove_admin/features/orders/order_details_screen.dart';
import 'package:mission_leftoverlove_admin/features/orders/orders_controller.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final ScrollController _scrollController = ScrollController();
  @override
  void didChangeDependencies() {}

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
    // SchedulerBinding.instance.addPostFrameCallback((_) {

    Future.microtask(
      () {
        final restaurantId =
            ref.read(globalOwnerModel.notifier).state?.restaurantId;
        ref.read(ordersControllerProvider.notifier).fetchOrders(restaurantId!);
      },
    );

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
              height: 40), // Optional: Adjust or remove if not needed
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade700,
                  Colors.orange.shade400
                ], // Orange theme
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(
                horizontal: 2), // Minimal horizontal margin
            child: Container(
              alignment: Alignment.centerLeft, // Align the TabBar to the left
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController, // Add a ScrollController
                child: Padding(
                  padding: EdgeInsets.zero, // Remove default padding
                  child: TabBar(
                    isScrollable: true,
                    controller: _controller,
                    onTap: (index) {
                      // Scroll to ensure the next tabs are visible
                      if (index >= 2) {
                        // Adjust this logic based on your needs
                        _scrollController.animateTo(
                          (index - 1) * 100, // Adjust scroll offset as needed
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 5, // Thickness of the indicator
                        color: Colors.deepOrange, // Orange theme
                      ),
                      borderRadius: BorderRadius.circular(10),
                      insets: EdgeInsets
                          .zero, // Remove default insets to cover the entire tab
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white.withOpacity(0.8),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 16, // Add horizontal padding to the tab text
                      vertical: 0, // No vertical padding
                    ),
                    tabs: const [
                      Tab(text: "booked"),
                      Tab(text: "picked"),
                      Tab(text: "noShowCancelled"),
                      Tab(text: "cancelled"),
                      Tab(text: "refund"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
              height: 20), // Optional: Adjust or remove if not needed
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                _buildOrderList(ref, "booked"),
                _buildOrderList(ref, "picked"),
                _buildOrderList(ref, "noShowCancelled"),
                _buildOrderList(ref, "cancelled"),
                _buildOrderList(ref, "refund"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a list of orders
  Widget _buildOrderList(WidgetRef ref, String status) {
    final orders =
        ref.watch(ordersControllerProvider).orders; // ✅ Ensure UI rebuilds

    final filteredOrders =
        orders.where((order) => order.orderStat == status).toList();

    print(
        "UI orders count: ${filteredOrders.length} for status: $status"); // Debugging

    if (filteredOrders.isEmpty) {
      return const Center(child: Text('No orders found.'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return OrderItemCard(
          order: order,
          onButtonPressed: () {
            // Add functionality for the button here
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(
                  orderId: order.orderId,
                ),
              ),
            );
            print('Order ID: ${order.orderId} button pressed');
          },
        );
      },
    );
  }
}
