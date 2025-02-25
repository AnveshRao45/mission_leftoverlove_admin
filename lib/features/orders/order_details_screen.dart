import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/menu_repo.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/order_food_item_card.dart';
import 'package:mission_leftoverlove_admin/features/orders/order_details_controller.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailsAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details : $orderId'),
      ),
      body: orderDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error in the orderDetailsAsync: $error')),
        data: (orderDetails) {
          if (orderDetails.isEmpty) {
            return const Center(child: Text('No order details found.'));
          }

          final orderDate = orderDetails.first.orderedDate;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order Date: ${orderDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: orderDetails.length,
                  itemBuilder: (context, index) {
                    final orderDetail = orderDetails[index];
                    return FutureBuilder<MenuModel>(
                      future: ref
                          .read(menuRepoProvider)
                          .getMenuItemById(orderDetail.menuItemId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No menu item found.'));
                        }

                        final menuItem = snapshot.data!;
                        return OrderFoodItemCard(
                          foodItem: menuItem, // Pass the menuItem directly
                          quantity: orderDetail.quantity, // Pass the quantity
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
