// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sia/pages/Shop/Center%20container/home_page_center_container.dart';
//import 'package:sia/pages/Shop/Center%20container/widgets/view_order.dart';

import '../../nav_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Nullable user
  User? user;
    //for viewing orders
  // String? selectedCustomerId;
  // String? selectedOrderId;

  @override
  void initState() {
    super.initState();
    // 2. Initialize user in initState
    user = FirebaseAuth.instance.currentUser;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("Shop Hub"), /// please edit
      ),

      body:  SafeArea(
        child: Row(
          children: [
           Expanded(
                flex: 2,
                child: SizedBox(
                  child: NavBar(),
                ),
              ),
            
            Expanded(
              flex: 9,
              child: SizedBox(
                child: HomePageCenterContainer(),
              ),
            ),

            
            // Expanded(
            //   flex: 3,
            //   child: SizedBox(
            //     child: selectedCustomerId != null && selectedOrderId != null
            //         ? ViewOrder(
            //             customerId: selectedCustomerId!,
            //             orderId: selectedOrderId!,
            //           )
            //         : Container(), // Empty container when no order is selected
            //   ),
            // ),
          
             
            Expanded(
              flex: 3,
              child: Container(
                color: Color.fromARGB(255, 195, 193, 190), // Change color as needed
                child: const Center(
                  child: Text('right side bar'),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
