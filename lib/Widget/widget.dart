import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';

class customDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(String)? onSelected;
  final Widget? customButton;
  final Color dropdownColor;
  final Color iconColor;
  final double dropdownWidth;

  const customDropdown({
    super.key,
    required this.items,
    this.onSelected,
    this.iconColor = Colors.black,
    this.customButton,
    this.dropdownColor = Colors.redAccent,
    this.dropdownWidth = 140,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton:
            customButton ?? const Icon(Icons.list, size: 20, color: Colors.red),
        items: items.map((item) {
          if (item['divider'] == true) {
            return const DropdownMenuItem<Divider>(
              enabled: false,
              child: Divider(),
            );
          }
          return DropdownMenuItem<String>(
            value: item['title'],
            child: Row(
              children: [
                Icon(item['icon'], color: item['color'] ?? iconColor, size: 20),
                const SizedBox(width: 10),
                Text(item['title'], style: AppFont.regular()),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null && onSelected != null) {
            onSelected!(value as String);
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: dropdownWidth,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: dropdownColor,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: List<double>.generate(items.length, (index) {
            if (items[index]['divider'] == true) return 8;
            return 48;
          }),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class customFloat extends StatelessWidget {
  const customFloat({super.key, required this.onPressed});
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onPressed();
      },
      highlightElevation: 5,
      child: Icon(FontAwesomeIcons.plus, color: Colors.white),
      backgroundColor: AppColor.primary,
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              height: 100,
              margin: EdgeInsets.only(bottom: 15),
              child: Image.asset(
                AppString.empty,
                height: 85,
                width: 85,
              )),
          Text(
            "Data Kosong",
            style: AppFont.regular(),
          )
        ],
      ),
    );
  }
}

class button_solid_custom extends StatelessWidget {
  const button_solid_custom({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.width,
    this.margin = const EdgeInsets.all(5),
    // required this.height,
  }) : super(key: key);

  final Function() onPressed;
  final Widget child;
  final double width;

  final EdgeInsetsGeometry margin;
  // final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: AppColor.secondary),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class button_border_custom extends StatelessWidget {
  const button_border_custom({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.width,
    this.margin = const EdgeInsets.all(5), // Optional margin with default value
  }) : super(key: key);

  final Function() onPressed;
  final Widget child;
  final double width;
  final EdgeInsetsGeometry margin; // Optional margin property

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin, // Use the optional margin
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(
            color: AppColor.secondary,
          ),
          foregroundColor: AppColor.secondary,
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class toast {
  void showErrorSnackbar(Map<String, dynamic> errorResponse) {
    // Check if the response has errors
    if (errorResponse['status'] == false && errorResponse['errors'] != null) {
      StringBuffer errorMessage = StringBuffer();

      // Iterate through the errors map
      errorResponse['errors'].forEach((key, value) {
        // Join the error messages for each field
        errorMessage.writeln('$key: ${value.join(', ')}');
      });

      // Show the snackbar with the formatted error message
      Get.showSnackbar(
        toast().bottom_snackbar_error(
          'Error',
          errorMessage.toString(),
        ),
      );
    } else {
      // Handle case where there are no errors or status is true
      Get.showSnackbar(
        toast().bottom_snackbar_error(
          'Error',
          'An unknown error occurred.',
        ),
      );
    }
  }

  void showDBErrorSnackbar(data) {
    // Check if the response has errors
    if (data == null) {
      Get.showSnackbar(
        toast().bottom_snackbar_error(
          'Error',
          'Database sqlite error'.toString(),
        ),
      );
    }
  }

  bottom_snackbar_error(
    String title,
    mesaage,
  ) {
    return GetSnackBar(
      title: title,
      message: mesaage,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      icon: Container(
          //margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.all(5),
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(Icons.error, color: AppColor.warning)),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.warning,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      duration: Duration(seconds: 2),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.elasticInOut,
      reverseAnimationCurve: Curves.easeOut,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  bottom_snackbar_success(String title, mesaage) {
    return GetSnackBar(
      title: title,
      message: mesaage,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      icon: Container(
          margin: EdgeInsets.only(
            left: 6,
          ),
          padding: EdgeInsets.all(5),
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(Icons.check, color: Colors.lightBlue[900])),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.cyan,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      duration: Duration(seconds: 1),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.elasticInOut,
      reverseAnimationCurve: Curves.easeOut,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  bottom_snackbar_connection_error(
    String title,
    mesaage,
  ) {
    return GetSnackBar(
      title: title,
      message: mesaage,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      icon: Container(
          margin: EdgeInsets.only(
            left: 6,
          ),
          padding: EdgeInsets.all(5),
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(Icons.error, color: AppColor.warning)),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      duration: Duration(seconds: 1),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.elasticInOut,
      reverseAnimationCurve: Curves.easeOut,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}

class AppbarCustomMain extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustomMain({
    super.key,
    required this.title,
  });
  final String title;
  //final double height;

  @override
  Size get preferredSize => Size.fromHeight(56);
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      actions: [
        Text(
          'Qasir pintar',
          style: AppFont.AppBarTitle(),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        title,
        style: AppFont.AppBarTitle(),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(15),
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
                //controller.openDrawer();
              },
              child: FaIcon(
                FontAwesomeIcons.list,
                color: Colors.white,
                size: 21,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppbarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustom({
    super.key,
    required this.title,
    required this.NeedBottom,
    this.BottomWidget,
  });

  final String title;
  final bool NeedBottom;
  final PreferredSizeWidget? BottomWidget;

  @override
  Size get preferredSize => Size.fromHeight(
      56 + (NeedBottom ? 50 : 0)); // Adjust height if BottomWidget is present

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      actions: [
        // Text(
        //   'Qasir pintar',
        //   style: AppFont.AppBarTitle(),
        // ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        title,
        style: AppFont.AppBarTitle(),
      ),
      iconTheme: IconThemeData(
        color: Colors.white, // Change your color here
      ),
      bottom:
          NeedBottom ? BottomWidget : null, // Conditionally add BottomWidget
    );
  }
}

class showloading extends StatelessWidget {
  const showloading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> _kDefaultRainbowColors = [
      AppColor.primary,
      AppColor.secondary,
      AppColor.accent,
      Colors.blue
    ];
    return Center(
      child: Container(
        width: 250,
        //height: 150,
        child: LoadingIndicator(
          indicatorType: Indicator.ballSpinFadeLoader,
          colors: _kDefaultRainbowColors,
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
      height: 40,
      width: 40,
      //padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}

class custom_list extends StatelessWidget {
  custom_list({
    super.key,
    this.gestureArgument,
    this.gestureroute,
    this.trailing,
    this.gambar,
    this.title,
    this.subtitle,
    this.controller,
    this.usingGambar = true,
    this.isDeleted = false,
  });

  final gestureArgument;
  final gestureroute;
  final trailing;
  final gambar;
  final title;
  final subtitle;
  final controller;
  bool? usingGambar = true;
  bool? isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return isDeleted == true ? _buildDeletedContainer() : _buildActiveList();
  }

  Widget _buildDeletedContainer() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          usingGambar == false ? _buildSimpleListTile() : _buildImageListTile(),
          const Divider(height: 0.5, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildActiveList() {
    return Column(
      children: [
        usingGambar == false
            ? GestureDetector(
                onTap: () =>
                    Get.toNamed(gestureroute, arguments: gestureArgument),
                child: _buildSimpleListTile())
            : GestureDetector(
                onTap: () =>
                    Get.toNamed(gestureroute, arguments: gestureArgument),
                child: _buildImageListTile(),
              ),
        const Divider(height: 0.5, color: Colors.black),
      ],
    );
  }

  Widget _buildSimpleListTile() {
    return ListTile(
      title: isDeleted == false
          ? Text(title, style: AppFont.regular_bold())
          : Text(
              title + '- Nonaktif',
              style: TextStyle(color: AppColor.warning),
            ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }

  Widget _buildImageListTile() {
    final hasValidImage = gambar != null && gambar != '-' && gambar!.isNotEmpty;

    return ListTile(
      leading: ClipOval(
        child: hasValidImage ? _buildValidImage() : _buildDefaultImage(),
      ),
      title: isDeleted == false
          ? Text(title, style: AppFont.regular_bold())
          : Text(
              title + '- Nonaktif',
              style: TextStyle(color: AppColor.warning),
            ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }

  Widget _buildValidImage() {
    final isSvg = controller.isBase64Svg(gambar!);
    final imageType = isSvg ? 'icon' : 'memory';

    return GestureDetector(
      onTap: () => heroPop(
        tag: gambar!,
        image: gambar!,
        type: imageType,
      ),
      child: isSvg
          ? SvgPicture.memory(
              base64Decode(gambar!),
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            )
          : Image.memory(
              base64Decode(gambar!),
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildDefaultImage() {
    return GestureDetector(
      onTap: () => heroPop(
        tag: AppString.defaultImg,
        image: AppString.defaultImg,
        type: 'asset',
      ),
      child: Image.asset(
        AppString.defaultImg,
        width: 45,
        height: 45,
        fit: BoxFit.contain,
      ),
    );
  }
}

class custom_list_produk extends StatelessWidget {
  custom_list_produk({
    super.key,
    this.gestureArgument,
    this.gestureroute,
    this.trailing,
    this.gambar,
    this.title,
    this.subtitle,
    this.controller,
    this.usingGambar = true,
    this.isDeleted = false,
  });

  final gestureArgument;
  final gestureroute;
  final trailing;
  final gambar;
  final title;
  final subtitle;
  final controller;
  bool? usingGambar = true;
  bool? isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return isDeleted == true ? _buildDeletedContainer() : _buildActiveList();
  }

  Widget _buildDeletedContainer() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          usingGambar == false ? _buildSimpleListTile() : _buildImageListTile(),
          const Divider(height: 0.5, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildActiveList() {
    return Column(
      children: [
        usingGambar == false
            ? GestureDetector(
                onTap: () =>
                    Get.toNamed(gestureroute, arguments: gestureArgument),
                child: _buildSimpleListTile())
            : GestureDetector(
                onTap: () =>
                    Get.toNamed(gestureroute, arguments: gestureArgument),
                child: _buildImageListTile(),
              ),
        const Divider(height: 0.5, color: Colors.black),
      ],
    );
  }

  Widget _buildSimpleListTile() {
    return ListTile(
      title: isDeleted == false
          ? Text(title, style: AppFont.regular_bold())
          : Text(
              title + '- Nonaktif',
              style: TextStyle(color: AppColor.warning),
            ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }

  Widget _buildImageListTile() {
    final hasValidImage = gambar != null && gambar != '-' && gambar!.isNotEmpty;

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.cyan,
        ),
        width: Get.width * 0.13,
        height: Get.height * 0.13,
        child: hasValidImage ? _buildValidImage() : _buildDefaultImage(),
      ),
      title: isDeleted == false
          ? Text(title, style: AppFont.regular_bold())
          : Text(
              title + ' - Nonaktif',
              style: TextStyle(color: AppColor.warning),
            ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }

  Widget _buildValidImage() {
    final isSvg = controller.isBase64Svg(gambar!);
    final imageType = isSvg ? 'icon' : 'memory';

    return GestureDetector(
      onTap: () => heroPop(
        tag: gambar!,
        image: gambar!,
        type: imageType,
      ),
      child: isSvg
          ? SvgPicture.memory(
              base64Decode(gambar!),
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            )
          : Image.memory(
              base64Decode(gambar!),
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildDefaultImage() {
    return GestureDetector(
      onTap: () => heroPop(
        tag: AppString.defaultImg,
        image: AppString.defaultImg,
        type: 'asset',
      ),
      child: Container(
        child: Image.asset(
          AppString.defaultImg,
          width: 45,
          height: 45,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColor.primary
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double startX = 3;

    // Top side
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right side
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom side
    startX = 3;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left side
    startY = 3;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
