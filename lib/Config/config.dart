import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: GoogleFonts.montserrat().fontFamily,
  primarySwatch: Colors.blue,
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: AppColor.primary,
      ),
  scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
  //backgroundColor: Colors.white, // Set background color to white
  // You can also set other colors if needed
);

class AppColor {
  static const Color primary = Color.fromRGBO(53, 161, 255, 1);
  static const Color secondary = Color.fromRGBO(0, 91, 155, 1.0);
  static const Color accent = Color.fromRGBO(253, 190, 0, 1);
  static const Color warning = Color.fromRGBO(229, 69, 69, 1);
  static const Color offwhite = Color.fromRGBO(246, 246, 246, 1);
}

class AppFont {
  static TextStyle regular({double fontSize = 12, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle regular_warning(
      {double fontSize = 12, Color color = AppColor.warning}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle small({double fontSize = 10, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle small_white(
      {double fontSize = 10, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle regular_bold(
      {double fontSize = 12, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle regular_white(
      {double fontSize = 12, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle regular_white_bold(
      {double fontSize = 12, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle big_white(
      {double fontSize = 28, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
    );
  }

  static TextStyle AppBarTitle(
      {double fontSize = 14, Color color = Colors.white}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle bold({double fontSize = 12, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle italic({double fontSize = 12, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      color: color,
    );
  }
}

class AppGradient {
  static Gradient customGradient() {
    return LinearGradient(
      colors: [AppColor.primary, AppColor.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Gradient customGradientv2() {
    return LinearGradient(
      colors: [AppColor.primary, AppColor.secondary],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}

class AppPading {
  static EdgeInsets defaultBodyPadding() {
    return const EdgeInsets.all(20.0);
  }

  static EdgeInsets customPadding({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? 17,
      bottom: bottom ?? 17,
      left: left ?? 17,
      right: right ?? 17,
    );
  }

  static EdgeInsets customBottomPadding() {
    return const EdgeInsets.only(bottom: 20);
  }

  static EdgeInsets customBottomPaddingSmall() {
    return const EdgeInsets.only(bottom: 10);
  }

  static EdgeInsets customTopPadding() {
    return const EdgeInsets.only(top: 20);
  }

  static EdgeInsets customLeftPadding() {
    return const EdgeInsets.only(left: 20);
  }

  static EdgeInsets customRightPadding() {
    return const EdgeInsets.only(right: 20);
  }
}

extension MediaQueryValues on BuildContext {
  double get res_width => MediaQuery.of(this).size.width;

  double get res_height => MediaQuery.of(this).size.height;
}

class AppString {
  static String defaultImg = 'assets/images/login_toko.png';
  static String empty = 'assets/icons/box.png';
}

class AppFormat {
  /// Converts a double like 50000.0 → "Rp 50.000"
  String formatRupiah(double amount) {
    final NumberFormat currencyFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFmt.format(amount);
  }

  numFormat(num) {
    return NumberFormat('#,###').format(num);
  }

  doubleFormat(num) {
    return double.parse(num.replaceAll(',', ''));
  }

  intFormat(num) {
    return int.parse(num.replaceAll(',', ''));
  }

  dateFormat(date) {
    final dateformat = DateFormat('dd-MM-yyyy');
    return dateformat.format(DateTime.parse(date));
  }
}
