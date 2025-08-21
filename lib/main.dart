import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/initial_binding.dart';

import 'Database/DB_helper.dart';
import 'Routes/routes.dart';
import 'Services/BoxStorage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  await DBHelper().db;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TubinMart',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      getPages: route,
      initialRoute: '/splash',
      initialBinding: InitialBinding(),
      //initialBinding: splashBinding(),
    );
  }
}
