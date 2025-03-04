import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/real_menu_model.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_controller.dart';

class UpdateFoodItemScreen extends ConsumerStatefulWidget {
  final int menuId;

  const UpdateFoodItemScreen({super.key, required this.menuId});

  @override
  ConsumerState<UpdateFoodItemScreen> createState() =>
      _UpdateFoodItemScreenState();
}

class _UpdateFoodItemScreenState extends ConsumerState<UpdateFoodItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  late TextEditingController itemNameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController actualPriceController;
  late TextEditingController imageController;
  late TextEditingController quantityController;
  late TextEditingController categoryIdController;
  late TextEditingController subcategoryIdController;

  bool isVeg = false;
  bool isActive = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchMenuItem();
  }

  void _initializeControllers() {
    itemNameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    actualPriceController = TextEditingController();
    imageController = TextEditingController();
    quantityController = TextEditingController();
    categoryIdController = TextEditingController();
    subcategoryIdController = TextEditingController();
  }

  Future<void> _fetchMenuItem() async {
    try {
      final menuController = ref.read(menuControllerProvider.notifier);
      RealMenuModel? menuItem =
          await menuController.getRealMenuItemById(widget.menuId);

      if (!mounted) return;

      if (menuItem != null) {
        setState(() {
          itemNameController.text = menuItem.itemName ?? "";
          descriptionController.text = menuItem.description ?? "";
          priceController.text = menuItem.price?.toString() ?? "";
          actualPriceController.text = menuItem.actualPrice?.toString() ?? "";
          imageController.text = menuItem.image ?? "";
          quantityController.text = menuItem.quantity?.toString() ?? "";
          categoryIdController.text = menuItem.categoryId?.toString() ?? "";
          subcategoryIdController.text =
              menuItem.subcategoryId?.toString() ?? "";
          isVeg = menuItem.isVeg ?? false;
          isActive = menuItem.isActive ?? false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Menu item not found";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Error fetching menu item: $e";
      });
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    actualPriceController.dispose();
    imageController.dispose();
    quantityController.dispose();
    categoryIdController.dispose();
    subcategoryIdController.dispose();
    super.dispose();
  }

  Future<void> _updateFoodItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      RealMenuModel updatedItem = RealMenuModel(
        menuId: widget.menuId,
        itemName: itemNameController.text.trim(),
        restaurantId: ref.read(globalOwnerModel)?.restaurantId,
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        isVeg: isVeg,
        actualPrice: double.tryParse(actualPriceController.text) ?? 0.0,
        image: imageController.text.trim(),
        quantity: int.tryParse(quantityController.text) ?? 0,
        categoryId: int.tryParse(categoryIdController.text),
        subcategoryId: int.tryParse(subcategoryIdController.text),
        isActive: isActive,
      );

      try {
        final menuController = ref.read(menuControllerProvider.notifier);
        bool success = await menuController.updateFoodItem(updatedItem);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? "Menu updated successfully"
                : "Failed to update menu item"),
          ),
        );

        if (success) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating menu: $e")),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Food Item"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(itemNameController, "Item Name",
                              required: true),
                          _buildTextField(descriptionController, "Description",
                              maxLines: 3),
                          _buildTextField(priceController, "Price",
                              keyboardType: TextInputType.number,
                              required: true),
                          _buildTextField(actualPriceController, "Actual Price",
                              keyboardType: TextInputType.number,
                              required: true),
                          _buildTextField(imageController, "Image URL",
                              required: true),
                          _buildTextField(quantityController, "Quantity",
                              keyboardType: TextInputType.number,
                              required: true),
                          _buildTextField(categoryIdController, "Category ID",
                              keyboardType: TextInputType.number,
                              required: true),
                          _buildTextField(
                              subcategoryIdController, "Subcategory ID",
                              keyboardType: TextInputType.number,
                              required: true),
                          SwitchListTile(
                            title: const Text("Is Veg"),
                            value: isVeg,
                            onChanged: (value) => setState(() => isVeg = value),
                          ),
                          SwitchListTile(
                            title: const Text("Is Active"),
                            value: isActive,
                            onChanged: (value) =>
                                setState(() => isActive = value),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateFoodItem,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Update Food Item"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: required
            ? (value) => value == null || value.trim().isEmpty
                ? "Please enter $label"
                : null
            : null,
      ),
    );
  }
}
