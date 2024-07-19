import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sia/pages/Shop/Center%20container/widgets/add_order_dialog.dart';
import 'package:sia/pages/Shop/Center%20container/widgets/view_order.dart';


import 'package:sia/services/firestore.dart';  // Import Firestore

class OrderListsWidget extends StatefulWidget {
  const OrderListsWidget({super.key});


  @override
  State<OrderListsWidget> createState() => _OrderListsWidgetState();
}

class _OrderListsWidgetState extends State<OrderListsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService(); // Create an instance
  
  get firestoreService => FirestoreService;

  void openAddOrderDialog(BuildContext context, String customerId) {
    showDialog(
      context: context,
      builder: (context) => AddOrderDialog(
        customerId: customerId,
        onAddOrder: (products) async {
          // 1. Save the order:
           await _firestoreService.addOrder(customerId, products); // Use the instance

          //for recording sale_data
          double totalSaleAmount = 0;
          for (var product in products) {
            totalSaleAmount += product['price'] * product['quantity']; 
          }

          // Record the sale
          _firestoreService.recordSale(totalSaleAmount); 

          // 2. Update product quantities:
          for (var product in products) {
            String productId = product['id'];
            int quantitySold = product['quantity'];
        
            //int currentQuantity = productDoc.get('quantity');
            int initialQuantity = product['initialQuantity']; // Get initial quantity
            await _firestoreService.updateProductQuantity(productId, initialQuantity - quantitySold);
            await _firestoreService.addSaleDetails(productId, quantitySold); // Record the sale
          }

   
          setState(() {
            // Refresh order list or show a success message
          });
        },
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('customers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final customers = snapshot.data!.docs;

            return _buildOrderList("Pending Orders", Colors.orange, customers);
          },
        ),
       // _buildOrderList("Completed Orders", Colors.green, []), // No need for customers here
      ],
    );
  }

  Widget _buildOrderList(
    String title,
    Color color,
    List<QueryDocumentSnapshot> customers
  ) {
    // ... (Container styling remains the same)

    return Column(
      // ...

      children: <Widget>[
        // ... (title container remains the same)
        if (customers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),  
          )
        else
          ...customers.map((customer) => _buildCustomerListItem(customer)),
        // ... (Completed Orders section remains the same)
      ],
    );
  }

   Widget _buildCustomerListItem(QueryDocumentSnapshot customer) {
    return StreamBuilder<QuerySnapshot>(
      stream: customer.reference.collection('orders').orderBy('timestamp', descending: true).limit(1).snapshots(),
      builder: (context, orderSnapshot) {
        if (orderSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        var latestOrder = orderSnapshot.data?.docs.isNotEmpty == true ? orderSnapshot.data!.docs[0] : null;
        return ListTile(
          title: Text(customer['plate number'] ?? 'No plate number'),
          subtitle: Text(customer['customer name'] ?? 'Unknown'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  openAddOrderDialog(context, customer.id);
                },
              ),
              if (latestOrder != null)
                IconButton(
                  icon: const Icon(Icons.remove_red_eye), 
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewOrder(
                        orderId: latestOrder.id, 
                        customerId: customer.id,
                      ),
                    ));
                  },
                ),
            ],
          ),
          onTap: () {
            // ... (Handle item tap for customer details)
          },
        );
      },
    );
  }


}

