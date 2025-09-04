import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:qasir_pintar/Services/Handler.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';
import 'controller_loginform.dart';

class LoginForm extends GetView<LoginFormController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Login', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.loginKey(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masuk ke akun',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Belum punya akun?'),
                            TextSpan(
                              text: ' Daftar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/register');
                                },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 0.7,
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.black,
                      ))
                    ],
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.email.value,

                      decoration: InputDecoration(
                        labelText: 'Nomor handphone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      //keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukan nomor handphone';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      obscureText: controller.showpass.value,
                      controller: controller.password.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: controller.showpass == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            controller.showpass.value =
                                !controller.showpass.value;
                            print(controller.showpass.value);
                          },
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukan Password';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Container(
                  margin: EdgeInsets.all(5),
                  width: context.res_width * 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.secondary,
                    ),
                    onPressed: () {
                      if (controller.loginKey.value.currentState!.validate()) {
                        // controller.login();
                        controller.loginLocal(
                            hp: controller.email.value.text,
                            pass: controller.password.value.text);
                      }

                      //controller.fetchUserLocal(6);
                    },
                    child: Text(
                      'Masuk',
                      style: AppFont.regular_white_bold(),
                    ),
                  ),
                ),
                SizedBox(height: 17.0),
                // Align(
                //   alignment: Alignment.center,
                //   child: TextButton(
                //     onPressed: () {
                //       // Handle forgot password logic here
                //     },
                //     child: Text('Lupa Password?'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
