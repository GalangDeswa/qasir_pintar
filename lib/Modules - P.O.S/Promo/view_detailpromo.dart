import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Config/config.dart';
import '../../Widget/widget.dart';
import 'controller_detailpromo.dart';

class DetailPromo extends GetView<DetailPromoController> {
  const DetailPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Detail Promo',
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
                  _buildDetailTile(
                      title: 'Kode promo', value: controller.data.namaPromo!),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Nilai promo',
                      value: controller.data.promoNominal != 0.0
                          ? 'Rp, ' +
                              AppFormat()
                                  .numFormat(controller.data.promoNominal)
                          : '% ' + controller.data.promoPersen.toString()),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Masa promo',
                      value: controller.date1 + ' - ' + controller.date2),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Keterangan', value: controller.data.keterangan!),
                  Divider(height: 0, thickness: 0.5),
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
