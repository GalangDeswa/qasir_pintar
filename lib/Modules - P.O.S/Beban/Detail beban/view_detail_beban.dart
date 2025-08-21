import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_detail_beban.dart';

class DetailBeban extends GetView<DetailBebanController> {
  const DetailBeban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail Beban', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  _buildDetailTile(
                      title: 'Beban', value: controller.data.namaBeban!),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Jumlah',
                      value:
                          'Rp ${NumberFormat('#,###').format(controller.data.jumlahBeban)}'),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Kategori',
                      value: controller.data.kategoriBeban ?? '-'),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Di tambah oleh',
                      value: controller.data.namaKaryawan ?? '-'),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Tanggal',
                      value: controller.data.tanggalBeban ?? '-'),
                  Divider(height: 0, thickness: 0.5),
                  _buildSwitchTile(
                      title: 'Aktif', value: controller.data.aktif == 1),
                ],
              ),
            ],
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
