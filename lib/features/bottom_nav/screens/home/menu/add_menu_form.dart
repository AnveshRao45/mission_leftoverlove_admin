import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/real_menu_model.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_controller.dart';

class ImprovedAddMenuForm extends ConsumerStatefulWidget {
  const ImprovedAddMenuForm({super.key});

  @override
  ConsumerState<ImprovedAddMenuForm> createState() =>
      _ImprovedAddMenuFormState();
}

class _ImprovedAddMenuFormState extends ConsumerState<ImprovedAddMenuForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers with meaningful initial values and validation
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _quantityController =
      TextEditingController(text: "1");
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _actualPriceController =
      TextEditingController();
  late final TextEditingController _imageController = TextEditingController();

  int? _selectedCategoryId;
  bool _isVeg = true;

  List<Map<String, dynamic>> categories = [];

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

  // Enhanced form validation with descriptive error messages
  String? _validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? _validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    return null;
  }

  void _submitMenuItem() async {
    // Comprehensive form validation
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")),
        );
        return;
      }

      final menuController = ref.read(menuControllerProvider.notifier);
      final resId = ref.read(globalOwnerModel)!.restaurantId;

      RealMenuModel newMenuItem = RealMenuModel(
        menuId: 6, // Consider generating this dynamically
        restaurantId: resId,
        itemName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        actualPrice: double.parse(_actualPriceController.text),
        isVeg: _isVeg,
        image: _imageController.text.trim(),
        categoryId: _selectedCategoryId!,
        subcategoryId: _selectedCategoryId!, // This might need refinement
        isActive: true,
      );

      // Improved error handling with user-friendly messages
      try {
        bool success = await menuController.addMenuItem(newMenuItem);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Menu item added successfully"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to add menu item. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred: $e"),
            backgroundColor: Colors.red,
          ),
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
          autovalidateMode: AutovalidateMode
              .onUserInteraction, // Immediate validation feedback
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enhanced text fields with clear validation
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Menu Item Name",
                  prefixIcon: Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validateNonEmpty(value, 'Menu Item Name'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) => _validateNonEmpty(value, 'Description'),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: "Quantity",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumeric(value, 'Quantity'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => _validateNumeric(value, 'Price'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _actualPriceController,
                      decoration: InputDecoration(
                        labelText: "Actual Price",
                        prefixIcon: Icon(Icons.local_offer),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          _validateNumeric(value, 'Actual Price'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _imageController,
                      decoration: InputDecoration(
                        labelText: "Image URL",
                        prefixIcon: Icon(Icons.image),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _validateNonEmpty(value, 'Image URL'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Enhanced dropdown with error handling
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['id'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 12),
              // More intuitive switch for dietary preference
              SwitchListTile.adaptive(
                title: const Text("Vegetarian Item"),
                subtitle: Text(_isVeg
                    ? "This is a vegetarian menu item"
                    : "This is a non-vegetarian menu item"),
                value: _isVeg,
                onChanged: (value) => setState(() => _isVeg = value),
              ),
              SizedBox(height: 16),
              // Enhanced submit button with visual hierarchy
              ElevatedButton.icon(
                onPressed: _submitMenuItem,
                icon: Icon(Icons.add_circle_outline),
                label: Text("Add Menu Item", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Proper resource management
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _actualPriceController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
