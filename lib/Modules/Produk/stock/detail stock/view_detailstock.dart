import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';
import 'controller_detailstock.dart';

class DetailStock extends GetView<DetailStockController> {
  const DetailStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail stock', NeedBottom: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              margin: AppPading.defaultBodyPadding(),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildDetailTile(
                        title: 'Nama Produk',
                        value: controller.data.nama_produk!),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'Kode Produk',
                        value: controller.data.kode_produk == null ||
                                controller.data.kode_produk == ''
                            ? '-'
                            : controller.data.kode_produk!),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'Harga Beli',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_beli)}'),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'Qty', value: controller.data.qty.toString()),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'Nilai Persediiaan',
                        value:
                            (controller.data.harga_beli! * controller.data.qty!)
                                .toString()),
                    Divider(height: 20, thickness: 1),
                    button_solid_custom(
                        onPressed: () {
                          controller.createPDF(controller.data);
                          //  controller.dir();
                          //controller.openPDF();
                        },
                        child: Text('Export PDF'),
                        width: Get.width)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: null, // Disabled switch for display
        activeColor: AppColor.primary,
      ),
    );
  }
}
