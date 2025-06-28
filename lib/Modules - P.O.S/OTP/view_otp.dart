import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/OTP/controller_otp.dart';

class OTP extends GetView<OTPController> {
  const OTP({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final verifikasi_kode = TextEditingController();
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proteksi akun',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                            'Demi keamanan data akun, akun ini dilindungi dengan kode OTP yang akan dikirim oleh melalui Email'),
                      ),
                    ],
                  ),
                  //Text('Masukan kode verifikasi'),
                  Container(
                    height: 200,
                    child: Lottie.asset('assets/animation/verifikasi.json',
                        animate: true, fit: BoxFit.cover, repeat: false),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text('Kode verifikasi telah di kirim ke email')),
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
                                shape: PinCodeFieldShape.box,
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
                                Get.offAndToNamed('/loginpin');
                              },
                              child: Text('Verifikasi'),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Kode tidak terkirim? ',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: ' kirim ulang',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offAndToNamed('/loginpin');
                                      },
                                    style: TextStyle(color: Colors.blue))
                              ]))
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
