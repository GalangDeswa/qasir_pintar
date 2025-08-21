import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class SplashController extends GetxController {
  final int minSplashMs = 3000;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    // Timer(const Duration(seconds: 3), () async {
    //   await checkLogin();
    // });
  }

  @override
  void onReady() {
    super.onReady();

    //startSplashTimerAndChecks();
    checkLogin();
  }

  void startSplashTimerAndChecks() {
    // 1) “timerDone” completes in minSplashMs ms.
    final timerDone = Future.delayed(Duration(milliseconds: minSplashMs));

    // 2) “storageDone” completes when we finish reading/writing from GetStorage.
    final storageDone = checkLoginWork();

    // 3) Wait for BOTH to finish (i.e. max(minSplashMs, storage time)) before navigating.
    Future.wait([timerDone, storageDone]).then((_) {
      // Once both futures are done, navigation has already been triggered inside _checkLoginWork()
      // (We separated the logic so that _checkLoginWork does the actual Get.offNamed(...) call).
    });
  }

  Future<void> checkLoginWork() async {
    final box = GetStorage();
    final hasSeenIntro = await box.read<bool>('intro');
    final uuid = await box.read<String>('uuid');

    if (hasSeenIntro != true) {
      await box.write('intro', true);
      Get.offNamed('/intro');
      return;
    }

    if (uuid != null && uuid.isNotEmpty) {
      Get.offNamed('/basemenu');
    } else {
      Get.offNamed('/login');
    }
  }

  Future<void> checkLoginWorkv2() async {
    final box = GetStorage();
    final hasSeenIntro = await box.read<bool>('intro');
    final uuid = await box.read<String>('uuid');

    if (hasSeenIntro != true) {
      await box.write('intro', true);
      Get.offNamed('/intro');
      return;
    }

    if (uuid != null && uuid.isNotEmpty) {
      Get.offNamed('/basemenu');
    } else {
      Get.offNamed('/login');
    }
  }

  // checkLogin() async {
  //   var loginStatus = await GetStorage().read('uuid');
  //   var check = await GetStorage().read('intro');
  //   print(
  //       'check intro----------------------------------------------------------->');
  //   print(check);
  //
  //   print("LOGIN " + loginStatus.toString());
  //   if (check == null) {
  //     await GetStorage().write('intro', true);
  //     Timer(const Duration(seconds: 3), () {
  //       Get.offAndToNamed('/intro');
  //     });
  //   } else {
  //     if (loginStatus != null) {
  //       //await fetchKontenSquare();
  //       Timer(const Duration(seconds: 3), () {
  //         Get.offAndToNamed('/basemenu');
  //       }
  //           //     {
  //           //   Get.off(const Dashboard());
  //           // }
  //           );
  //     } else {
  //       //await fetchKontenSquare();
  //       // await GetStorage().read('konten_banner');
  //       Timer(const Duration(seconds: 3), () {
  //         Get.offAndToNamed('/login');
  //       });
  //     }
  //   }
  // }

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
        Timer(const Duration(seconds: 3), () {
          Get.offAndToNamed('/basemenu');
        });
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAndToNamed('/login');
        });
      }
    }
  }
}
