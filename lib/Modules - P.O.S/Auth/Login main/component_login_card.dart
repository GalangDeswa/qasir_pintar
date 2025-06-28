import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';

import 'package:qasir_pintar/Widget/widget.dart';

import 'controller_login.dart';

class LoginCard extends GetView<LoginController> {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.res_width * 100,
      height: context.res_height * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: button_solid_custom(
              child: Text('Masuk', style: AppFont.regular_white_bold()),
              width: context.res_width * 0.65,
              onPressed: () {
                Get.toNamed('/loginform');
              },
            ),
          ),
          button_border_custom(
            onPressed: () {
              Get.toNamed('/register');
            },
            child: Text('Daftar', style: AppFont.regular_bold()),
            width: context.res_width * 0.65,
          )
        ],
      ),
    );
  }
}
