import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Services/BoxStorage.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';

/// Simple GetX middleware to guard routes based on roles stored in BoxStorage
class RoleMiddleware extends GetMiddleware {
  final StorageService box = Get.find<StorageService>();

  /// List of roles allowed to access the route
  final List<String> allowedRoles;

  RoleMiddleware({required this.allowedRoles});

  @override
  int? get priority => 0;

  /// Called before navigation; show login dialog if no role, or redirect if unauthorized
  @override
  RouteSettings? redirect(String? route) {
    print('<----- ROLE MIDDLEWARE ----->');
    // Read role from storage (assumes you saved it during login)
    final role = box.read('karyawan_role', fallback: '');
    print('middleware role-------> $role');

    // If no role selected, prompt login pop-up and cancel navigation
    //TODO : middleware || beban
    if (role.isEmpty) {
      var check = Popscreen().karyawanLoginv2();
      if (check == 'ADMIN') {
        print('qweghqwkuehqikuwehukqweh');
      }
      return RouteSettings(name: Get.currentRoute);
    }

    // If role not allowed, redirect to unauthorized page
    if (!allowedRoles.contains(role)) {
      return const RouteSettings(name: '/unauthorized');
    }

    // allowed
    return null;
  }
}
