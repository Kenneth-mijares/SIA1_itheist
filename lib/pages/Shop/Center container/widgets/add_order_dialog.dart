import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sia/services/firestore.dart'; 

class AddOrderDialog extends StatefulWidget {
  final String customerId;
  final Function(List<Map<String, dynamic>>) onAddOrder;

  const AddOrderDialog({super.key, required this.customerId, required this.onAddOrder});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Map<String, dynamic>> _selectedProducts = [];
  //int _quantity = 0; // Quantity of the current product
  double _totalPrice = 0.0; // Total price of the order
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch products when the dialog opens
    _fetchProducts();
  }
  //ffetch or read the customer list
  Future<void> _fetchProducts() async {
    try {
      await _firestoreService.productsCollection.get();
    } catch (e) {
      // Handle error fetching products
      // ignore: avoid_print
      print("Error fetching products: $e");
      // You can show an error message to the user here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

   void _addProductToOrder(String productId) async {
    DocumentSnapshot productDoc = await _firestoreService.productsCollection.doc(productId).get();
    setState(() {
      _selectedProducts.add({
        'id': productId,
        'name': productDoc.get('product name'),
        'price': productDoc.get('price'),
        'initialQuantity': productDoc.get('quantity'),
        'quantity': 1, // Initial quantity
        'distributionTime': productDoc.get('distribution time'), // Initial distribution time
      });
      _totalPrice += productDoc.get('price');
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Order'),
      content: SizedBox(
        // height: double.maxFinite,
        // width: double.maxFinite,
        height: 500,
        width: 500,
        child: Column(
          children: [
            if (_selectedProducts.isNotEmpty)
              Column(
                children: [
                  Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 10,
                    
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = _selectedProducts[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Price: \$${product['price']} x ${product['quantity']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (product['quantity'] > 1) {
                                    _selectedProducts[index]['quantity']--;
                                    _totalPrice -= product['price'];
                                  } else {
                                    _selectedProducts.removeAt(index);
                                    _totalPrice -= product['price'];
                                  }
                                });
                              },
                            ),
                            Text(product['quantity'].toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _selectedProducts[index]['quantity']++;
                                  _totalPrice += product['price'];
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ElevatedButton(
              child: const Text('Add Product'),
              onPressed: () async {
                List<DocumentSnapshot> products = (await _firestoreService.productsCollection.get()).docs;
        
                // Filter out already selected products
                products = products.where((product) => 
                  !_selectedProducts.any((selected) => selected['id'] == product.id)
                ).toList();
        
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Select Product'),
                    children: products.map((product) => SimpleDialogOption(
                      child: Text(product.get('product name')),
                      onPressed: () { 
                        Navigator.of(context).pop(); 
                        _addProductToOrder(product.id); 
                      },
                    )).toList(),
                  ),
                );
              },
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
            widget.onAddOrder(_selectedProducts);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
