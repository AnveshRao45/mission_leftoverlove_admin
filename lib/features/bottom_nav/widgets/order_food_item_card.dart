import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';

class OrderFoodItemCard extends StatelessWidget {
  final MenuModel foodItem;
  final int quantity;

  const OrderFoodItemCard({
    super.key,
    required this.foodItem,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodItem.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: $quantity',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${foodItem.price}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
