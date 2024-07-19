import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _customersCollection =
      FirebaseFirestore.instance.collection('customers');

  final CollectionReference _salesDataCollection =
      FirebaseFirestore.instance.collection('sales_data');

  // CREATE

  //for product creation
  Future<void> addProduct(
      String productName,
      String productBrand,
      String productType,
      int quantity,
      double price,
      int distributionTime
      ) {
    return productsCollection.add({
      'product name': productName,
      'product brand': productBrand,
      'product type': productType,
      'quantity': quantity,
      'price': price,
      'distribution time': distributionTime,
      'timestamp': Timestamp.now(),
    });
  }

  //for customer creation
  Future<void> addCustomer(
      String plateNumber,
      String customerName,
      String carModel,
      String contactNumber,
      int mileage
      ) {
    return _customersCollection.add({

      'plate number' : plateNumber,
      'customer name' : customerName,
      'car model' : carModel,
      'contact number' : contactNumber,
      'mileage' : mileage,
      'timestamp': Timestamp.now(),
    });
  }

  //for creating sales_data collection

  Future<void> recordSale(double amount) async {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = '${now.year}-${now.month.toString().padLeft(2, '0')}'; // YYYY-MM
    final day = '${now.year}-D${now.day.toString().padLeft(2, '0')}'; // YYYY-W##

    // 1. Update year document
    await _salesDataCollection.doc(year).set({
      'salesAmount': FieldValue.increment(amount),
      'timestamp': FieldValue.serverTimestamp(), 
    }, SetOptions(merge: true)); // Create if it doesn't exist

    // 2. Update month subcollection
    await _salesDataCollection.doc(year).collection('months').doc(month).set({
      'salesAmount': FieldValue.increment(amount),
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 3. Update week subcollection
    await _salesDataCollection.doc(year).collection('months').doc(month)
        .collection('days').doc(day).set({
      'salesAmount': FieldValue.increment(amount),
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // for geting the sales data
  Future<Map<String, double>> getSalesData(String timePeriod, [String parent = '']) async {
    QuerySnapshot snapshot;
    if (parent.isEmpty) { 
      snapshot = await _salesDataCollection.where(FieldPath.documentId, isEqualTo: timePeriod).get();
    } else {
      snapshot = await _salesDataCollection
          .doc(parent)
          .collection(timePeriod == 'months' ? 'months' : 'days')
          .where(FieldPath.documentId, isEqualTo: timePeriod)
          .get();
    }

    Map<String, double> salesData = {};
    for (var doc in snapshot.docs) {
      salesData[doc.id] = doc['salesAmount'];
    }
    return salesData;
  }


// restocking features

Future<void> addRestockDetails(String productId, int quantityAdded, int distributionTime) async {
    final restockRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('restockHistory')
        .doc(); // Generate a new document ID for each restock

    await restockRef.set({
      'quantityAdded': quantityAdded,
      'distributionTime': distributionTime,
    });

    // Update the product's quantity and calculate average/highest distribution time
    final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
    await productRef.update({
      'quantity': FieldValue.increment(quantityAdded),
      'averageDistributionTime': FieldValue.increment(distributionTime),
      'highestDistributionTime': FieldValue.increment(distributionTime),
    });

    // Perform the calculations (see next section)
    await _updateDistributionTimeStats(productId);
    await updateReorderPoint(productId);
  }

    Future<void> _updateDistributionTimeStats(String productId) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
    final restockHistoryQuery = await productRef.collection('restockHistory').get();

    int totalDistributionTime = 0;
    int highestDistributionTime = 0;
    int restockCount = restockHistoryQuery.docs.length;

    for (var doc in restockHistoryQuery.docs) {
      final data = doc.data();
      int distributionTime = data['distributionTime'];
      totalDistributionTime += distributionTime;

      if (distributionTime > highestDistributionTime) {
        highestDistributionTime = distributionTime;
      }
    }

    double averageDistributionTime = restockCount > 0 ? (totalDistributionTime / restockCount).toDouble() : 0;
    await productRef.update({
      'averageDistributionTime': averageDistributionTime,
      'highestDistributionTime': highestDistributionTime,
    });
  }


//salesHistory features

Future<void> addSaleDetails(String productId, int quantitySold) async {
    final saleRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('salesHistory')
        .doc(); // Auto-generate sale ID

    await saleRef.set({
      'quantitySold': quantitySold,
      'timestamp': FieldValue.serverTimestamp(), // Optional
    });

    // Update product stats (average and max sold)
    await _updateSalesStats(productId);
    await updateReorderPoint(productId); // Add this line
  }

  Future<void> _updateSalesStats(String productId) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
    final salesHistoryQuery = await productRef.collection('salesHistory').get();

    int totalSold = 0;
    int maxSold = 0;

    for (var doc in salesHistoryQuery.docs) {
      final data = doc.data();
      int quantitySold = data['quantitySold'];
      totalSold += quantitySold;

      if (quantitySold > maxSold) {
        maxSold = quantitySold;
      }
    }

    double averageSold = salesHistoryQuery.docs.isNotEmpty ? (totalSold / salesHistoryQuery.docs.length).toDouble() : 0;
    await productRef.update({
      'averageSold': averageSold,
      'maxSold': maxSold,
    });
  }

  //reorder point calculation

  Future<void> updateReorderPoint(String productId) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
    final productDoc = await productRef.get();

    if (!productDoc.exists) {
      // Handle case where product doesn't exist
      return;
    }

    final data = productDoc.data() as Map<String, dynamic>;
    final averageSold = data['averageSold'] ?? 0.0; // Default to 0 if null
    final highestDistributionTime = data['highestDistributionTime'] ?? 0; // Default to 0 if null
    final averageDistributionTime = data['averageDistributionTime'] ?? 0;
    final maxSold = data['maxSold'] ?? 0; // Default to 0 if null

    final reorderPoint = (averageSold * highestDistributionTime) +
        ((maxSold * highestDistributionTime) - (averageSold * averageDistributionTime));


    int roundedReorderPoint = reorderPoint.floor();
    await productRef.update({
      'reorderPoint': roundedReorderPoint,
    });
  }



// Add an order

Future<Future<DocumentReference<Map<String, dynamic>>>> addOrder(String customerId, List<Map<String, dynamic>> products) async {
  double totalPrice = 0.0; // Initialize total price

  // Calculate the total price
  for (var product in products) {
    String productId = product['id'];
    int quantity = product['quantity'];

    DocumentSnapshot productDoc = await productsCollection.doc(productId).get();
    double productPrice = productDoc.get('price');
    totalPrice += productPrice * quantity;

    // Update product quantity (reduce by the ordered amount)
    int currentQuantity = productDoc.get('quantity');
    await updateProductQuantity(productId, currentQuantity - quantity);
  }

  // Save the order with total price
  return _customersCollection
    .doc(customerId)
    .collection('orders')
    .add({
      'products': products,
      'total_price': totalPrice,
      'timestamp': Timestamp.now(),
    });
}




  // READ
  //read products
  Stream<QuerySnapshot> getProductsStream() {
    final productsStream =
        productsCollection.orderBy('timestamp', descending: true).snapshots();

    return productsStream;

    
  }
  //read orders
  Stream<QuerySnapshot> getCustomerOrdersStream(String customerId) {
  return _customersCollection
    .doc(customerId)
    .collection('orders')
    .snapshots();
  }

  

  //UPDATE

  //for updateing quantity of products upon completion of orders:

  Future<void> updateProductQuantity(
    String productId, 
    int newQuantity) {
    return productsCollection.doc(productId).update({'quantity': newQuantity});

    }



  //DELETE

}
