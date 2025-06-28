import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Home%20-%20distributor/controller_home_distributor.dart';

class HomeDistributor extends GetView<HomeDistributorController> {
  const HomeDistributor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/under.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This feature is under development.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
