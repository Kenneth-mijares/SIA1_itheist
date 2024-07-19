import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductDialog extends StatefulWidget {
  final Function(
      String productName,
      String productBrand,
      String productType,
      int quantity,
      double price,
      int distributionTime) onAddProduct;

  const AddProductDialog({super.key, required this.onAddProduct});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productBrandController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _distributionTimeController = TextEditingController();

  void _addProduct() {
    final String productName = _productNameController.text;
    final String productBrand = _productBrandController.text;
    final String productType = _productTypeController.text;
    final int quantity = int.parse(_quantityController.text);
    final double price = double.parse(_priceController.text);
    final int distributionTime = int.parse(_distributionTimeController.text);

    widget.onAddProduct(productName, productBrand, productType, quantity, price, distributionTime);

    // Clear the text fields
    _productNameController.clear();
    _productBrandController.clear();
    _productTypeController.clear();
    _quantityController.clear();
    _priceController.clear();
    _distributionTimeController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text fields for product details (same as before)
            TextField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _productBrandController,
                decoration: const InputDecoration(labelText: 'Product Brand'),
              ),
              TextField(
                controller: _productTypeController,
                decoration: const InputDecoration(labelText: 'Product Type'),
              ),
              
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (Pesos)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextField(
                controller: _distributionTimeController,
                decoration: const InputDecoration(labelText: 'Distribution Time (days)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addProduct();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

