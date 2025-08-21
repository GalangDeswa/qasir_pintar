import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../Kasir/model_penjualan.dart';
import 'controller_riwayatpenjualan.dart';

class HistoryPenjualan extends GetView<HistoryPenjualanController> {
  const HistoryPenjualan({Key? key}) : super(key: key);

  /// Converts "YYYY-MM-DD" → "Sabtu, 17 Mei 2025"
  String _formatIndonesianDate(String isoDate) {
    try {
      DateTime parsed;
      // Try ISO first
      try {
        parsed = DateTime.parse(isoDate);
      } catch (_) {
        // If fails, try dd-MM-yyyy (Indonesian style)
        parsed = DateFormat("dd-MM-yyyy").parse(isoDate);
      }

      final DateFormat indFmt = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
      return indFmt.format(parsed);
    } catch (e) {
      return isoDate; // fallback
    }
  }

  /// Converts a double like 50000.0 → "Rp 50.000"
  String _formatRupiah(double amount) {
    final NumberFormat currencyFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFmt.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralHistoryController>();
    return Scaffold(
      appBar: AppbarCustom(title: 'Riwayat Penjualan', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Column(
          children: [
            // ── Search bar row ─────────────────────────────────────────────

            Obx(() {
              return customDatesearch(
                  onReset: () {
                    con.fetchRiwayatPenjualan(id_toko: con.id_toko);
                  },
                  sortValue: con.isAsc.value,
                  onSortPressed: () {
                    con.toggleSortPenjualan();
                  },
                  onOkTap: () {
                    print('custom dates');
                    con.fetchRiwayatPenjualanByTanggal(
                        id_toko: con.id_toko,
                        startDate: con.date1.toString(),
                        endDate: con.date2.toString());
                  },
                  textController: con.pickdate.value,
                  dates: con.dates,
                  onDateChanged: (dates) {
                    var list = <String>[];
                    var start = dates.first;
                    final end = dates.last;
                    con.pickdate.value.text = (con.dateformat.format(start!) +
                        ' - ' +
                        con.dateformat.format(end!));

                    con.date1 = start;
                    con.date2 = end;
                    print(con.date1);
                    print(con.date2);
                  });
            }),

            Container(
              //height: 100,
              //color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Riwayat'),
                ],
              ),
            ),
            Container(
              height: 0.9,
              color: Colors.black,
              width: context.res_width,
              margin: EdgeInsets.only(bottom: 10),
            ),

            // ── The scrolling list of grouped transactions ─────────────────
            Expanded(
              child: Obx(() {
                final List<DataPenjualanByDate> groups = con.groupedPenjualan;

                if (groups.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada data lagi.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }

                // We’ll flatten the groups → a single list of widgets:
                final List<Widget> slivers = [];

                for (final group in groups) {
                  // 1) Date header
                  slivers.add(_buildDateHeader(group));

                  // 2) Thick divider under the date header
                  slivers.add(Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade300,
                  ));

                  // 3) One transaction row per item
                  for (final item in group.items) {
                    slivers.add(_buildTransactionRow(item));
                    // Light divider (indented) after each row
                    slivers.add(Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.grey.shade200,
                      indent: 64, // so it doesn’t run under the icon
                    ));
                  }

                  // 4) Add some vertical spacing before next date group
                  slivers.add(const SizedBox(height: 16));
                }

                return ListView(
                  children: slivers,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the date header row: "Sabtu, 17 Mei 2025    Rp 105.000"
  Widget _buildDateHeader(DataPenjualanByDate group) {
    var parsed = AppFormat().dateFormat(group.date);
    final String totalStr = _formatRupiah(group.totalForDate.toDouble());

    return Container(
      color: AppColor.primary.withValues(alpha: 0.1),
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              parsed,
              style: AppFont.regular(fontSize: 14),
            ),
          ),
          Text(
            totalStr,
            style: AppFont.regular_bold(color: Colors.green, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Builds a single transaction row (no time column here):
  ///
  /// [icon]   #12345ABC        Rp 50.000
  ///          Tunai
  Widget _buildTransactionRow(PenjualanItem item) {
    var con = Get.find<CentralHistoryController>();
    final String amountStr = _formatRupiah(item.totalBayar);
    var penjualan = con.penjualan;
    var x = penjualan.where((p) => p.uuid == item.uuidPenjualan).first;

    return x.reversal != 1
        ? custom_list(
            gestureroute: '/detail_history',
            gestureArgument: x,
            usingGambar: false,
            title: item.noFaktur,
            trailing: Text(amountStr),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total item : ' + item.totalqty.toString(),
                    style: AppFont.regular())
              ],
            ),
          )
        : Container(
            color: Colors.red.withValues(alpha: 0.2),
            child: custom_list(
              gestureroute: '/detail_history',
              gestureArgument: x,
              usingGambar: false,
              title: item.noFaktur,
              trailing: Text(amountStr),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total item : ' + item.totalqty.toString(),
                      style: AppFont.regular()),
                  Text('Reversal', style: AppFont.regular(color: Colors.red))
                ],
              ),
            ),
          );
  }
}
