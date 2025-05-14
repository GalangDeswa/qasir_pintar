import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    Timer(const Duration(seconds: 3), () async {
      await checkLogin();
    });
  }

  checkLogin() async {
    var loginStatus = await GetStorage().read('uuid');
    var check = await GetStorage().read('intro');
    print(
        'check intro----------------------------------------------------------->');
    print(check);

    print("LOGIN " + loginStatus.toString());
    if (check == null) {
      await GetStorage().write('intro', true);
      Timer(const Duration(seconds: 3), () {
        Get.offAndToNamed('/intro');
      });
    } else {
      if (loginStatus != null) {
        //await fetchKontenSquare();
        Timer(const Duration(seconds: 3), () {
          Get.offAndToNamed('/basemenu');
        }
            //     {
            //   Get.off(const Dashboard());
            // }
            );
      } else {
        //await fetchKontenSquare();
        // await GetStorage().read('konten_banner');
        Timer(const Duration(seconds: 3), () {
          Get.offAndToNamed('/login');
        });
      }
    }
  }
}
