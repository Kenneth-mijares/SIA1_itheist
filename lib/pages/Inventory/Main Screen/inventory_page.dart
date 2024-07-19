import 'package:flutter/material.dart';
import 'package:sia/pages/Inventory/Center%20Container/inventory_center_container.dart';
import 'package:sia/pages/nav_bar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: const Text('Inventory Hub'),
      ),
      body: SafeArea(
        child: Row(
          children: [

            //navbar 
            const Expanded(
                flex: 2,
                child: SizedBox(
                  child: NavBar(),
                ),
              ),

              //center container
            const Expanded(
              flex: 9,
              child: SizedBox(
                child: InventoryCenterContainer(),
              ),
            ),

            //right side bar
            Expanded(
              flex: 3,
              child: Container(
                color:  const Color.fromARGB(255, 195, 193, 190), // Change color as needed
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
