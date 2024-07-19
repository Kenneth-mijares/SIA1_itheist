import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sia/constants/product_list_tile.dart';
import 'package:sia/pages/Inventory/Center%20Container/Widgets/restock_dialog.dart';
import 'package:sia/services/firestore.dart';
import 'add_product_dialog.dart'; 

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final FirestoreService firestoreService = FirestoreService();

  void openProductBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onAddProduct: (productName, productBrand, productType, quantity, price, distributionTime) {
          firestoreService.addProduct(
            productName,
            productBrand,
            productType,
            quantity,
            price,
            distributionTime,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => openProductBox(context),
            child: const Text('Add Product'),
          ),
       
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              
              return Column(
                children: List.generate(documents.length, (index) {
                  final doc = documents[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return MinimalistListTile(
                    title: data['product name'],
                    subtitle: 'Brand: ${data['product brand']}',
                    trailingText: '₱ ${data['price'].toString()}',
                    onTap: () {}, // You can add onTap logic here
                    onUpdateInfo: () {}, // Add update info logic here
                    onRestock: () {

                      showDialog(
                        context: context,
                        builder: (context) => RestockDialog(
                          productId: doc.id,
                          onRestock: (quantityAdded, distributionTime) {
                            firestoreService.addRestockDetails(doc.id, quantityAdded, distributionTime);
                          },
                        ),
                      );

                    },
                    onDelete: () {}, // Add restock logic here
                  );
                  
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

