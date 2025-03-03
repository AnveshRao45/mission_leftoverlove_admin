import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/food_item_card.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(menuControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Items"),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final foodItem = menuItems[index];
          return FoodItemCard(foodItem: foodItem);
        },
      ),
    );
  }
}
