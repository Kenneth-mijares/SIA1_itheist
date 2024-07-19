// import 'package:flutter/material.dart';
// import 'package:sia/services/firestore.dart';




// class SalesLineChart extends StatefulWidget {
//   const SalesLineChart({super.key});

//   // ...

//   @override
//   _SalesLineChartState createState() => _SalesLineChartState();
// }

// class _SalesLineChartState extends State<SalesLineChart> {
//   final FirestoreService _firestoreService = FirestoreService();
//   String selectedYear = DateTime.now().year.toString(); // Default to current year
//   Map<String, double> monthlySales = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchSalesData(); 
//   }

//   Future<void> _fetchSalesData() async {
//     monthlySales = await _firestoreService.getSalesData(selectedYear);
//     setState(() {}); // Update the chart data
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DropdownButton<String>(
//           value: selectedYear,
//           items: List.generate(10, (index) => (DateTime.now().year - index).toString())
//               .map((year) => DropdownMenuItem(
//                     value: year,
//                     child: Text(year),
//                   ))
//               .toList(),
//           onChanged: (year) {
//             setState(() {
//               selectedYear = year!;
//               _fetchSalesData();
//             });
//           },
//         ),
//         LineChart(
//           LineChartData(
//             titlesData: FlTitlesData(
//               show: true,
//               bottomTitles: SideTitles(
//                 showTitles: true,
//                 getTitles: (value) => monthNames[value.toInt() - 1], 
//                 // Map 1-12 to month names (Jan, Feb, etc.)
//               ),
//               leftTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 28,
//                 getTitles: (value) => (value / 1000).toString() + 'k', // Format as '1k', '2k', etc.
//               ),
//             ),
//             gridData: FlGridData(show: true),
//             borderData: FlBorderData(show: true),
//             lineBarsData: [
//               LineChartBarData(
//                 spots: monthlySales.entries.map((entry) {
//                   int month = int.parse(entry.key.split('-')[1]);
//                   return FlSpot(month.toDouble(), entry.value);
//                 }).toList(),
//                 isCurved: true,
//                 colors: gradientColors, // Define gradient colors (e.g., blue to green)
//                 barWidth: 5,
//                 dotData: FlDotData(show: false),
//                 belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => color.withOpacity(0.3)).toList()),
//               ),
//             ],
//           )

//         ),
//       ],
//     );
//   }

//   // ... (Rest of your widget code - LineChartData details will be added here)
// }
