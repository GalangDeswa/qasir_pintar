import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../Controllers/CentralController.dart';

class LoginRequired extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const LoginRequired(
      {required this.child, required this.allowedRoles, super.key});

  @override
  Widget build(BuildContext context) {
    //TODO : FIX THIS
    return Obx(() {
      final controller = Get.find<CentralKaryawanController>();
      var authRole = controller.role.value;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        print('Post-frame callback');
        final success = await controller.popLoginKaryawan(allowedRoles);
        print('popLoginKaryawan success: $success');
        if (success) {
          print('succ');
        }
      });
      // var authRole = controller.role.value;
      // if (allowedRoles.contains(authRole)) {
      //   //Get.snackbar('Berhasil', 'akses berhasil');
      //   return child; // Show the page content if role is allowed
      // } else {
      //   print('-------------------------------------------------------->');
      //   print('role tidak ada di $allowedRoles');
      //   // Get.snackbar('gagal', 'hanya $allowedRoles yang bisa mengakses');
      //   //  Get.back(closeOverlays: true);
      //
      //   // Show loading while login is pending
      // }
      return child;
    });

    // return Obx(() {
    //   final controller = Get.find<CentralKaryawanController>();
    //   //controller.role.value = '';
    //   if (allowedRoles.contains(controller.role.value)) {
    //     return child; // Show the page content if role is allowed
    //   } else {
    //     // Trigger login sheet after the widget is built
    //     WidgetsBinding.instance.addPostFrameCallback((_) async {
    //       print('Post-frame callback');
    //       final success = await controller.popLoginKaryawan();
    //       print('popLoginKaryawan success: $success');
    //       if (!success) {
    //         print('Navigating back');
    //         Get.back();
    //         Get.back(); // Navigate back if login fails or is canceled
    //       }
    //     });
    //     return const Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     ); // Show loading while login is pending
    //   }
    // });
  }
}

class CustomRole extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const CustomRole({
    Key? key,
    required this.allowedRoles,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Defer popup until *after* this build frame completes:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Only show once per mount — guard with a flag on your controller:
    //   final ctrl = Get.find<CentralKaryawanController>();
    //   if (!ctrl.roleSheetShown.value) {
    //     ctrl.roleSheetShown.value = true;
    //     ctrl.popLoginKaryawanv2(allowedRoles);
    //   }
    // });

    return child;
  }
}
