import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/model_penjualan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_detailriwayatpenjualan.dart';

class DetailHistoryPenjualan extends GetView<DetailHistoryPenjualanController> {
  const DetailHistoryPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Detail Riwayat',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. Faktur',
                          style: AppFont.regular(),
                        ),
                        Text(
                          controller.data.noFaktur!,
                          style: AppFont.regular_bold(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Container(
                      height: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal transaksi',
                          style: AppFont.regular(),
                        ),
                        Text(
                          controller.data.tanggal!,
                          style: AppFont.regular_bold(),
                        )
                      ],
                    ),
                  ),
                  controller.data.idPelanggan == null ||
                          controller.data.idPelanggan == ''
                      ? Container()
                      : Padding(
                          padding: AppPading.customBottomPadding(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pelanggan',
                                style: AppFont.regular(),
                              ),
                              Text(
                                controller.data.namaPelanggan!,
                                style: AppFont.regular_bold(),
                              )
                            ],
                          ),
                        ),
                  button_border_custom(
                      onPressed: () {},
                      child: Text('Reversal'),
                      width: Get.width),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_solid_custom(
                        onPressed: () async {
                          await controller.printstruk();
                        },
                        child: Text('Cetak struk'),
                        width: Get.width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Container(
                      height: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      'Detail Penjualan',
                      style: AppFont.regular(),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Produk',
                              style: AppFont.regular(),
                            ),
                            Text(
                              'Subtotal',
                              style: AppFont.regular(),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: AppPading.defaultBodyPadding(),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(() {
                            List<Widget> x = [];

                            for (final group in controller.detailpenjualan) {
                              x.add(Padding(
                                padding: EdgeInsets.only(bottom: 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${group.nama_produk != null ? group.nama_produk : group.namaPaket}',
                                      style: AppFont.regular_bold(),
                                    ),
                                    Text(
                                      'Rp. ' +
                                          AppFormat().numFormat(
                                            group.subtotal!,
                                          ),
                                      style: AppFont.regular(),
                                    )
                                  ],
                                ),
                              ));
                              x.add(Padding(
                                padding: EdgeInsets.only(bottom: 1),
                                child: Text('Qty :  ${group.qty}',
                                    style: AppFont.small()),
                              ));
                              x.add(Divider());
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: x,
                            );
                          }),
                        ),
                      ),
                      // Obx(() {
                      //   return Container(
                      //     height: 200,
                      //     color: Colors.red,
                      //     margin: AppPading.customBottomPadding(),
                      //     child: controller.detailpenjualan.isNotEmpty
                      //         ? ListView.builder(
                      //             itemCount: controller.detailpenjualan.length,
                      //             itemBuilder: (context, index) {
                      //               final customer = controller.detailpenjualan;
                      //
                      //               return Column(
                      //                 children: [
                      //                   ListTile(
                      //                     title: Text(
                      //                         customer[index].nama_produk!,
                      //                         style: AppFont.regular_bold()),
                      //                     subtitle: Text(
                      //                       'QTY :' +
                      //                           customer[index].qty.toString(),
                      //                       style: AppFont.regular(),
                      //                     ),
                      //                   ),
                      //                   Container(
                      //                     height: 0.5,
                      //                     color: Colors.black,
                      //                   )
                      //                 ],
                      //               );
                      //             },
                      //           )
                      //         : Center(child: Text('kosong')),
                      //   );
                      // }),
                      _buildDetailTile(
                          title: 'Jumlah produk',
                          value: controller.data.totalQty.toString()),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Subtotal',
                          value: 'Rp, ' +
                              AppFormat().numFormat(controller.data.subtotal)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Tanggal transaksi',
                          value: controller.data.tanggal!),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Total bayar',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.totalBayar)),
                      Divider(height: 0, thickness: 0.5),
                      // _buildDetailTile(
                      //     title: 'Total diskon',
                      //     value: 'Rp, ' +
                      //         AppFormat()
                      //             .numFormat(controller.data.totalDiskon)),
                      // Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Diskon nominal',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.diskonNominal)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Diskon persen',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.diskonPersen)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Kode promo',
                          value: controller.data.namaPromo ?? '-'),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Nilai promo',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.nilaiPromo)),
                      _buildDetailTile(
                          title: 'Total Pajak',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.totalPajak)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Jumlah bayar',
                          value: 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.nilaiBayar)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Kembalian',
                          value: 'Rp, ' +
                              AppFormat().numFormat(controller.data.kembalian)),
                      Divider(height: 0, thickness: 0.5),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: AppFont.regular(),
      ),
      subtitle: Text(
        value,
        style: AppFont.regular_bold(),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value}) {
    return ListTile(
      title: Text(
        title,
        style: AppFont.regular(),
      ),
      trailing: Switch(
        padding: EdgeInsets.zero,
        value: value, activeTrackColor: AppColor.primary,
        onChanged: null, // Disabled switch for display
        activeColor: AppColor.primary,
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    this.iconcolor,
  });

  final String text;
  final IconData icon;
  final bool? iconcolor;
}

abstract class MenuItems {
  static const List<MenuItem> secondItems = [Hapus];

  static const Hapus =
      MenuItem(text: 'Hapus', icon: Icons.delete, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.warning,
            size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: AppFont.regular(),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item,
      DetailHistoryPenjualanController controller, DataDetailPenjualan data) {
    switch (item) {
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
