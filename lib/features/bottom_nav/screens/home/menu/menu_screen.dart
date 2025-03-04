import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/add_menu_form.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/food_item_card.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(menuControllerProvider);
  }

  void _showAddFoodForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const ImprovedAddMenuForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Items"),
      ),
      body: menuItems.isEmpty
          ? const Center(child: Text("No menu items available"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final foodItem = menuItems[index];
                return FoodItemCard(foodItem: foodItem);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFoodForm(context),
        label: const Text("Add Food"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
