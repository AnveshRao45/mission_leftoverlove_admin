import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';

class FoodItemCard extends StatelessWidget {
  final MenuModel foodItem;

  const FoodItemCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            /// Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                foodItem.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            /// Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price: \$${foodItem.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Quantity Left: ${foodItem.quantity}",
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
