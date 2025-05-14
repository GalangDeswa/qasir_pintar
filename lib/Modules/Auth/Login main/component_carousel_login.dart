import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qasir_pintar/Config/config.dart';

import 'package:flutter/material.dart';

import 'controller_login.dart';

class CarouselLogin extends GetView<LoginController> {
  const CarouselLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Obx(() {
        return CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              controller.current(index);
            },
            viewportFraction: 1,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 6),
          ),
          items: controller.imgList.map((x) => Image.asset(x)).toList(),
        );
      }),
    );
  }
}
