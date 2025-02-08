import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/order_model.dart';

class OrderItemCard extends StatelessWidget {
  final Order order; // Accepts an Order object
  final VoidCallback onButtonPressed; // Callback for button functionality

  const OrderItemCard({
    super.key,
    required this.order,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // Adds a shadow to the card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID
            Text(
              'Order ID: ${order.orderId}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Spacing

            // User ID
            Text(
              'User ID: ${order.userId}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8), // Spacing

            // Order Date
            Text(
              'Order Date: ${order.orderDate.toLocal().toString().split(' ')[0]}', // Format date as YYYY-MM-DD
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16), // Spacing

            // Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onButtonPressed, // Callback for button functionality
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
