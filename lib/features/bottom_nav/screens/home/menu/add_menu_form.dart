import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_controller.dart';

class AddMenuForm extends ConsumerStatefulWidget {
  const AddMenuForm({super.key});

  @override
  ConsumerState<AddMenuForm> createState() => _AddMenuFormState();
}

class _AddMenuFormState extends ConsumerState<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _menuIdController = TextEditingController();
  final TextEditingController _restaurantIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _actualPriceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  bool _isVeg = true;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    categories =
        await ref.read(menuControllerProvider.notifier).fetchCategories();
    setState(() {});
  }

  Future<void> _fetchSubcategories(int categoryId) async {
    subcategories = await ref
        .read(menuControllerProvider.notifier)
        .fetchSubcategories(categoryId);
    setState(() {});
  }

  void _submitMenuItem() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final menuController = ref.read(menuControllerProvider.notifier);

      MenuModel newMenuItem = MenuModel(
        menuId: int.parse(_menuIdController.text),
        restaurantId: int.parse(_restaurantIdController.text),
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        actualPrice: double.parse(_actualPriceController.text),
        isVeg: _isVeg,
        image: _imageController.text,
        categoryName: _selectedCategoryId!,
        subcategoryName: _selectedSubcategoryId!,
        isActive: true,
      );

      bool success = await menuController.addMenuItem(newMenuItem);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Menu item added successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add Menu item")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _menuIdController,
                  decoration: const InputDecoration(labelText: "Menu ID"),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _restaurantIdController,
                  decoration: const InputDecoration(labelText: "Restaurant ID"),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Menu Name")),
              TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description")),
              TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _actualPriceController,
                  decoration: const InputDecoration(labelText: "Actual Price"),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: "Image URL")),

              /// Category Dropdown
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: "Category"),
                items: categories.map((cat) {
                  return DropdownMenuItem<int>(
                      value: cat['id'], child: Text(cat['name']));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                    _selectedSubcategoryId = null;
                    _fetchSubcategories(value!);
                  });
                },
              ),

              /// Subcategory Dropdown
              DropdownButtonFormField<int>(
                value: _selectedSubcategoryId,
                decoration: const InputDecoration(labelText: "Subcategory"),
                items: subcategories.map((sub) {
                  return DropdownMenuItem<int>(
                      value: sub['id'], child: Text(sub['name']));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategoryId = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text("Is Veg"),
                value: _isVeg,
                onChanged: (value) => setState(() => _isVeg = value),
              ),

              ElevatedButton(
                  onPressed: _submitMenuItem,
                  child: const Text("Add Menu Item")),
            ],
          ),
        ),
      ),
    );
  }
}
