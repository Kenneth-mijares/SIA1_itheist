
import 'package:flutter/material.dart';
import 'package:sia/pages/Inventory/Center%20Container/Widgets/product_list.dart';
import 'package:sia/pages/Inventory/Center%20Container/Widgets/search_widget.dart';

class InventoryCenterContainer extends StatefulWidget {
  const InventoryCenterContainer({super.key});

  @override
  State<InventoryCenterContainer> createState() => _InventoryCenterContainerState();
}

class _InventoryCenterContainerState extends State<InventoryCenterContainer> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          
          children: [
            
            SizedBox(height: 18),
            SearchWidget(),
            SizedBox(height: 18),
            ProductList(),
            SizedBox(height: 18),
            //const LineChartCard(),
            SizedBox(height: 18),
            //const BarGraphCard(),
            SizedBox(height: 18),
      
            

          ],
        ),
      ),
    );
  }
}
