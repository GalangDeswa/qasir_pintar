import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Kasir/component_produklist.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_basedataproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_pajak.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_ukuran.dart';
import 'package:qasir_pintar/Modules/Produk/Paket%20produk/view_paketproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/component_kelompokproduk.dart';
import 'package:qasir_pintar/Modules/Produk/component_kategorilist.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Config/config.dart';
import 'Data produk/view_listdatadettailproduk.dart';
import 'component_produklisst.dart';

class BasemenuProduk extends GetView<BaseMenuProdukController> {
  const BasemenuProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: customFloat(onPressed: () {
            // if (DefaultTabController.of(context).index == 0) {
            //   Get.toNamed('/tambahpelanggan');
            // } else {
            //   Get.toNamed('/tambahkategoripelanggan');
            // }
            switch (DefaultTabController.of(context).index) {
              case 0:
                Get.toNamed('/tambahprodukv3');
                break;
              case 1:
                Get.toNamed('/tambahpaketproduk');
                break;
              case 2:
                Get.toNamed('/tambahkategoriproduk');
                break;
              case 3:
                Get.toNamed('/tambahsubkategori');
                break;
              case 4:
                Get.toNamed('/tambahpajak');
                break;
              case 5:
                Get.toNamed('/tambahukuran');
                break;
            }
          }),
          appBar: AppbarCustom(
            title: 'Produk/ Kategori',
            NeedBottom: true,
            BottomWidget: TabBar(
              isScrollable: true,
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
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Produk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Paket',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Kategori',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Sub Kategori',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Pajak',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: context.res_width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Ukuran',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: AppPading.defaultBodyPadding(),
            child: TabBarView(children: [
              ViewBaseDataproduk(),
              PaketProduk(),
              KelompokProduk(),
              KategoriList(),
              ViewPajak(),
              ViewUkuran(),
            ]),
          ),
        );
      }),
    );
  }
}
