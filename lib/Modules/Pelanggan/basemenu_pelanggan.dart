import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/view_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/controller_basemenuPelanggan.dart';

import '../../Config/config.dart';
import '../../Widget/widget.dart';
import 'List Pelanggan/view_pelanggan.dart';

class BasemenuPelanggan extends GetView<BasemenuPelangganController> {
  const BasemenuPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          floatingActionButton: customFloat(onPressed: () {
            if (DefaultTabController.of(context).index == 0) {
              Get.toNamed('/tambahpelanggan');
            } else {
              Get.toNamed('/tambahkategoripelanggan');
            }
          }),
          appBar: AppbarCustom(
            title: 'Pelanggan',
            NeedBottom: true,
            BottomWidget: TabBar(
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, AppColor.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              labelColor: AppColor.secondary,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(FontAwesomeIcons.user),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Kategori',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: AppPading.defaultBodyPadding(),
            child: TabBarView(children: [Pelanggan(), KategoriPelanggan()]),
          ),
        );
      }),
    );
  }
}
