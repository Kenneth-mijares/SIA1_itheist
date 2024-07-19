import 'package:flutter/material.dart';
import 'package:sia/pages/Shop/Center%20container/widgets/camera.dart';
import 'package:sia/pages/Shop/Center%20container/widgets/order_list.dart';

class HomePageCenterContainer extends StatefulWidget {
  const HomePageCenterContainer({super.key});

  @override
  State<HomePageCenterContainer> createState() => _HomePageCenterContainerState();
}

class _HomePageCenterContainerState extends State<HomePageCenterContainer> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          
          children: [
            
            SizedBox(height: 18),
            //SearchWidget(),
            
            SizedBox(height: 18),
            Camera(),
            SizedBox(height: 18),
            OrderListsWidget(),
            SizedBox(height: 18),
            //const BarGraphCard(),
            SizedBox(height: 18),
      
            

          ],
        ),
      ),
    );
  }
}