import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../Widget/widget.dart';
import 'API.dart';

class check_conn {
  static Future<bool> check1() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult[0] == ConnectivityResult.mobile) {
      Get.snackbar('conn', 'mobile');
      try {
        final result = await InternetAddress.lookup("www.google.com");
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          return true;
        }
      } on SocketException catch (x) {
        print(
          'not connected mobile------------------------------------------------------------------------->',
        );
        Get.showSnackbar(
          toast().bottom_snackbar_error(
            'Error',
            'Periksa koneksi internet' + x.toString(),
          ),
        );
      }
    }
    if (connectivityResult[0] == ConnectivityResult.wifi) {
      Get.snackbar('conn', 'wifi');
      try {
        final result = await InternetAddress.lookup("www.google.com");
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          return true;
        }
      } catch (x) {
        print('not connected' + x.toString());
        Get.showSnackbar(
          toast().bottom_snackbar_connection_error(
            'Error',
            'Periksa koneksi internet' + x.toString(),
          ),
        );
      }
    }
    return false;
  }

  static Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    switch (connectivityResult[0]) {
      case ConnectivityResult.mobile:
        //  Get.snackbar('Connection', 'Connected via Mobile Data');
        return await checkInternetConnection();

      case ConnectivityResult.wifi:
        // Get.snackbar('Connection', 'Connected via WiFi');
        return await checkInternetConnection();

      case ConnectivityResult.ethernet:
        // Get.snackbar('Connection', 'Connected via Ethernet');
        return await checkInternetConnection();

      // case ConnectivityResult.bluetooth:
      //   Get.snackbar('Connection', 'Connected via Bluetooth');
      //   return await checkInternetConnection();

      case ConnectivityResult.none:
        Get.snackbar('Connection', 'No Internet Connection');
        return false;

      default:
        Get.snackbar('Connection', 'Unknown Connection Status');
        return false;
    }
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print(
            '------------------Connected to the Internet---------------------');
        return true;
      }
    } on SocketException catch (e) {
      print('Not connected to the Internet: $e');
      Get.showSnackbar(
        toast().bottom_snackbar_error(
          'Error',
          'Check your internet connection: $e',
        ),
      );
    }
    return false;
  }
}

class API extends GetConnect {
  static Future<dynamic> login(
      {required String email, required String password}) async {
    try {
      var response = await http.post(
        Link().POST_login,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email_telepon': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);

        var data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'handler--------------------------------------------------------->');
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return the response body even on error
        return jsonDecode(response.body); // Return the error response
      }
    } catch (e) {
      print('Error: $e');
      return {
        'error': 'An unexpected error occurred.'
      }; // Return a generic error message
    }
  }

  static Future<dynamic> getUser({required token, required id}) async {
    try {
      Uri getUser = Link().GET_User(id);
      var response = await http.get(
        getUser,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the headers
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);

        var data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'handler--------------------------------------------------------->');
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return the response body even on error
        return jsonDecode(response.body); // Return the error response
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<dynamic> registerUser({
    required String nama,
    required String email,
    required String telepon,
    String? koderef,
    required String password,
    required String konPassword,
  }) async {
    try {
      var response = await http.post(
        Link().POST_register,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'telepon': telepon,
          'kode_referal': koderef,
          'password': password,
          'konfirmasi_password': konPassword
        }),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);

        var data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'handler--------------------------------------------------------->');
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return the response body even on error
        return jsonDecode(response.body); // Return the error response
      }
    } catch (e) {
      print('Error: $e');
      return {
        'error': 'An unexpected error occurred.'
      }; // Return a generic error message
    }
  }

  static Future<dynamic> getProvince({required token}) async {
    try {
      Uri api = Link().GET_province;
      var response = await http.get(
        api,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the headers
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);

        var data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'handler--------------------------------------------------------->');
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return the response body even on error
        return jsonDecode(response.body); // Return the error response
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<dynamic> getRegency(
      {required String token, required int province}) async {
    try {
      Uri getRegency = Link().GET_regency(province);
      var response = await http.get(
        getRegency,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<dynamic> getDistrict(
      {required String token,
      required int province,
      required int regency}) async {
    try {
      Uri getDistrict = Link().GET_district(province, regency);
      var response = await http.get(
        getDistrict,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
