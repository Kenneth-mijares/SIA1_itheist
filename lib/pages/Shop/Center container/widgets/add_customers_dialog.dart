import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCustomersDialog extends StatefulWidget {
  final Function(
      String plateNumber,
      String customerName,
      String carModel,
      String contactNumber,
      int mileage) onAddCustomer;

  const AddCustomersDialog({super.key, required this.onAddCustomer});

  @override
  State<AddCustomersDialog> createState() => _AddCustomersDialogState();
}

class _AddCustomersDialogState extends State<AddCustomersDialog> {
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();


  void _addCustomer() {
  final String plateNumber = _plateNumberController.text;
  final String customerName = _customerNameController.text;
  final String carModel = _carModelController.text;
  final String contactNumber = _contactNumberController.text;
  final int mileage = int.parse(_mileageController.text);



    widget.onAddCustomer(plateNumber, customerName, carModel, contactNumber, mileage);

    // Clear the text fields
    _plateNumberController.clear();
    _customerNameController.clear();
    _carModelController.clear();
    _contactNumberController.clear();
    _mileageController.clear();
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
                controller: _plateNumberController,
                decoration: const InputDecoration(labelText: 'Plate Number'),
              ),
              TextField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: _carModelController,
                decoration: const InputDecoration(labelText: 'Exact Car Model'),
              ),
              
              TextField(
                controller: _contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Mileage'),
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
            _addCustomer();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

