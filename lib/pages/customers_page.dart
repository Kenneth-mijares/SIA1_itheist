import 'package:flutter/material.dart';
import 'package:sia/pages/nav_bar.dart';


class CUstomerPage extends StatefulWidget {
  const CUstomerPage({super.key});

  @override
  State<CUstomerPage> createState() => _CUstomerPageState();
}

class _CUstomerPageState extends State<CUstomerPage> {
    @override
  Widget build(BuildContext context) {
    return  Scaffold(

      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Customers Hub'),
      ),

      body: const Center(
        child: Text("customer page"),
    
      ),

    );
  }
}