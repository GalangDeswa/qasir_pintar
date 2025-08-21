import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Config/config.dart';
import 'component_carousel_login.dart';
import 'component_login_card.dart';
import 'controller_login.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primary,
        body: Stack(
          children: [
            Positioned(
                child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      // colorFilter: ColorFilter.mode(
                      //     Colors.white.withOpacity(0.5), BlendMode.dstATop),
                      fit: BoxFit.cover)),
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    //color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            'TubinMart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 35),
                          ),
                        ),
                        CarouselLogin(),
                        Expanded(
                          child: Obx(() {
                            return CarouselSlider(
                              options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  controller.current(index);
                                },
                                viewportFraction: 1.0,
                                height: 500,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 6),
                              ),
                              items: controller.textList
                                  .map((x) => Text(
                                        x,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ))
                                  .toList(),
                            );
                          }),
                        ),
                        Obx(() {
                          return Expanded(
                            child: DotsIndicator(
                              dotsCount: controller.imgList.length,
                              position: controller.current.toDouble(),
                              decorator: DotsDecorator(
                                size: const Size.square(10.0),
                                color: Colors.grey,
                                activeColor: Colors.white,
                                activeSize: const Size(50.0, 9.0),
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                LoginCard()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
