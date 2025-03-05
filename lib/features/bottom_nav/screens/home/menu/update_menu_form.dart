import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/real_menu_model.dart';
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

  bool? isVeg; // Changed to nullable, no default
  bool? isActive; // Changed to nullable, no default
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
          isVeg = menuItem.isVeg; // No default, reflect model exactly
          isActive = menuItem.isActive; // No default, reflect model exactly
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
    final menuController = ref.read(menuControllerProvider.notifier);
    RealMenuModel? menuItem =
        await menuController.getRealMenuItemById(widget.menuId);
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      RealMenuModel updatedItem = RealMenuModel(
        menuId: widget.menuId,
        itemName: itemNameController.text.trim(),
        restaurantId: menuItem?.restaurantId,
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        isVeg: isVeg,
        actualPrice: double.tryParse(actualPriceController.text) ?? 0.0,
        image: imageController.text.trim(),
        quantity: int.tryParse(quantityController.text) ?? 0,
        categoryId: int.tryParse(categoryIdController.text),
        subcategoryId: int.tryParse(subcategoryIdController.text),
        isActive: isActive,
        cuisine: menuItem?.cuisine,
      );

      try {
        bool success = await menuController.updateFoodItem(updatedItem);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? "Menu updated successfully"
                : "Failed to update menu item"),
            backgroundColor:
                success ? Colors.green.shade700 : Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        if (success) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating menu: $e"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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
        elevation: 0,
        backgroundColor:
            const Color(0xFFF4511E), // Warm orange for a food theme
        title: const Text(
          "Edit Menu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4511E), Color(0xFFE64A19)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFF5F5F5)
            ], // Cream to light grey
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF4511E),
                  strokeWidth: 3,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.restaurant_menu,
                                      color: Color(0xFFF4511E), size: 28),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Update Menu Details",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(itemNameController, "Menu Name",
                                  required: true),
                              _buildTextField(
                                  descriptionController, "Description",
                                  maxLines: 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        priceController, "Price",
                                        keyboardType: TextInputType.number,
                                        required: true),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                        actualPriceController, "Actual Price",
                                        keyboardType: TextInputType.number,
                                        required: true),
                                  ),
                                ],
                              ),
                              _buildTextField(imageController, "Image URL",
                                  required: true),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        quantityController, "Quantity",
                                        keyboardType: TextInputType.number,
                                        required: true),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                        categoryIdController, "Category ID",
                                        keyboardType: TextInputType.number,
                                        required: true),
                                  ),
                                ],
                              ),
                              _buildTextField(
                                  subcategoryIdController, "Subcategory ID",
                                  keyboardType: TextInputType.number,
                                  required: true),
                              const SizedBox(height: 20),
                              _buildSwitchTile(
                                  "Vegetarian",
                                  isVeg ?? false, // Display as false if null
                                  (value) => setState(() => isVeg = value)),
                              _buildSwitchTile(
                                  "Active",
                                  isActive ?? false, // Display as false if null
                                  (value) => setState(() => isActive = value)),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _updateFoodItem,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 16),
                                    backgroundColor: const Color(0xFFF4511E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 5,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Save Changes",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          prefixIcon: Icon(
            _getIconForLabel(label),
            color: const Color(0xFFF4511E),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF4511E), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
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

  Widget _buildSwitchTile(
      String title, bool? value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: value == null ? Colors.grey.shade200 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: SwitchListTile(
          title: Text(
            title + (value == null ? " (Not Set)" : ""),
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey.shade800),
          ),
          value: value ?? false, // Still defaults to false for the switch
          activeColor: const Color(0xFFF4511E),
          onChanged: onChanged,
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case "Menu Name":
        return Icons.fastfood;
      case "Description":
        return Icons.description;
      case "Price":
      case "Actual Price":
        return Icons.attach_money;
      case "Image URL":
        return Icons.image;
      case "Quantity":
        return Icons.format_list_numbered;
      case "Category ID":
      case "Subcategory ID":
        return Icons.category;
      default:
        return Icons.edit;
    }
  }
}
