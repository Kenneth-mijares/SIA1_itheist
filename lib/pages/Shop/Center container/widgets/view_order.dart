import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrder extends StatelessWidget {
  final String orderId;
  final String customerId;

  const ViewOrder({super.key, required this.orderId, required this.customerId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View/Edit Order"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customers')
            .doc(customerId)
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;
          var products = orderData['products'];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('Price: ₱${product['price']} x ${product['quantity']}'),
                // Add edit/remove buttons or other actions as needed
              );
            },
          );
        },
      ),
    );
  }
}
