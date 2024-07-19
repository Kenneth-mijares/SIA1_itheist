
import 'package:flutter/material.dart';
//import 'package:sia/pages/analytics/Center%20Container/WIdgets/sales_linechart.dart';


class AnalyticsCenterContainer extends StatefulWidget {
  const AnalyticsCenterContainer({super.key});

  @override
  State<AnalyticsCenterContainer> createState() => _AnalyticsCenterContainerState();
}

class _AnalyticsCenterContainerState extends State<AnalyticsCenterContainer> {
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
            //SalesLineChart(),
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
