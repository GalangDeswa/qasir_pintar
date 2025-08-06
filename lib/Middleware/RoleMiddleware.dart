import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/CentralController.dart';

// class AuthMiddleware extends GetMiddleware {
//   final List<String> allowedRoles;
//   AuthMiddleware({required this.allowedRoles});
//
//   @override
//   int? get priority => 0;
//
//   @override
//   GetPage? onPageCalled(GetPage? page) {
//     final role = Get.find<CentralKaryawanController>().role;
//
//     if (!allowedRoles.contains(role)) {
//       // pop the sheet on *current* page
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Get.find<CentralKaryawanController>().popLoginKaryawan();
//       });
//       return null;
//     }
//     // role allowed → proceed with this page
//     return page;
//   }
// }
