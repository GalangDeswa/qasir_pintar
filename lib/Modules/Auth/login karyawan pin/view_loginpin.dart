import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';
import 'controller_loginpin.dart';

class LoginPin extends GetView<LoginPinController> {
  const LoginPin({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final verifikasi_kode = TextEditingController();
    return Scaffold(
        appBar: AppbarCustom(
          title: 'Verifikasi',
          NeedBottom: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Text(
                          'Toko Berkah',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih jenis usaha';
                          }
                          return null;
                        },
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white)),
                        hint: Text('Pilih Karyawan', style: AppFont.regular()),
                        value: controller.jenisvalue,
                        items: controller.karyawan.map((x) {
                          return DropdownMenuItem(
                            child: Text(x),
                            value: x.toString(),
                          );
                        }).toList(),
                        onChanged: (val) {
                          controller.jenisvalue = val!.toString();
                          print(controller.jenisvalue);
                        },
                      ),
                      SizedBox(height: 100.0),
                    ],
                  ),
                  //Text('Masukan kode verifikasi'),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: 350,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          PinCodeTextField(
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.circle,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveColor: AppColor.primary),
                            animationDuration: Duration(milliseconds: 300),
                            //backgroundColor: Colors.blue.shade50,
                            controller: verifikasi_kode,
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                            appContext: context,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 350,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColor.secondary),
                              onPressed: () {
                                Get.offAndToNamed('/basemenu');
                              },
                              child: Text('Masuk'),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // RichText(
                          //     text: TextSpan(
                          //         text: 'Kode tidak terkirim? ',
                          //         style: TextStyle(color: Colors.black),
                          //         children: <TextSpan>[
                          //       TextSpan(
                          //           text: ' kirim ulang',
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               Get.offAndToNamed('/loginpin');
                          //             },
                          //           style: TextStyle(color: Colors.blue))
                          //     ])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
