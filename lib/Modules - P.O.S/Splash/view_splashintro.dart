import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:qasir_pintar/Config/config.dart';

import 'controller_splash.dart';

class intro extends GetView<SplashController> {
  const intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntroSlider(
          onDonePress: () {
            Get.offAndToNamed('/login');
          },
          indicatorConfig: IndicatorConfig(
              colorActiveIndicator: AppColor.primary,
              colorIndicator: Colors.white),
          nextButtonStyle: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          prevButtonStyle: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          doneButtonStyle: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          skipButtonStyle: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          listContentConfig: [
            ContentConfig(
              title: "qasir pintar",
              styleTitle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              pathImage: "assets/icons/splash.png",
              description: "Aplikasi P.O.S lengkap",
              styleDescription: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              backgroundImage: "assets/images/bg.png",
            ),
            ContentConfig(
              styleTitle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              styleDescription: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              title: "Fitur lengkap",
              pathImage: "assets/images/intro2.png",
              description: "Nikmati berbagai fitur menarik qasir pintar",
              backgroundImage: "assets/images/bg.png",
            ),
            ContentConfig(
              styleTitle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              styleDescription: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              title: "Transaksi kapan saja",
              pathImage: "assets/images/intro3.png",
              description: "lakukan transaksi offline maupun online",
              backgroundImage: "assets/images/bg.png",
            ),
          ],
        ),
      ),
    );
  }
}
