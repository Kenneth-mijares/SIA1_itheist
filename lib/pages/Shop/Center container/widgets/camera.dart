
import 'package:flutter/material.dart';
import 'package:sia/constants/custom_card_widget.dart';
import 'package:sia/pages/Shop/Center%20container/widgets/add_customers_dialog.dart';


import 'package:sia/services/firestore.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final FirestoreService firestoreService = FirestoreService();
  String? selectedCustomerId; // Track selected customer for orders

  void openAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCustomersDialog(
        onAddCustomer: (plateNumber, customerName, carModel, contactNumber,
            mileage) async {
          await firestoreService.addCustomer(
            plateNumber,
            customerName,
            carModel,
            contactNumber,
            mileage,
          );

          
          // Get and store the newly created customer's ID
          setState(() {
            selectedCustomerId;
          });
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 6,
          child: CustomCard(
            child: AspectRatio(
              aspectRatio: 16 / 9,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column( // Use a column for two buttons
            children: [
              ElevatedButton(
                onPressed: () => openAddCustomerDialog(context),
                child: const Text('Add Customer'),
              ),
             
            ],
          ),
        ),
      ],
    );
  }
}
