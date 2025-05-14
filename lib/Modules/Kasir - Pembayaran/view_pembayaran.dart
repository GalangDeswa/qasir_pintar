import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/component_Bottommenu_pembayaran.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Config/config.dart';

class Pembayaran extends GetView<PembayaranController> {
  const Pembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Keranjang',
        NeedBottom: false,
      ),
      body: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0.5)),
                      height: 200,
                      margin: AppPading.defaultBodyPadding(),
                      child: controller.keranjang.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.keranjang.length,
                              itemBuilder: (context, index) {
                                final customer = controller.keranjang;

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            // leading: ClipOval(
                                            //   child: customer[index]
                                            //       .gambar_produk_utama !=
                                            //       '' &&
                                            //       customer[index]
                                            //           .gambar_produk_utama !=
                                            //           null
                                            //       ? controller.isBase64Svg(
                                            //       customer[index]
                                            //           .gambar_produk_utama!)
                                            //       ? SvgPicture.memory(
                                            //     base64Decode(customer[
                                            //     index]
                                            //         .gambar_produk_utama!),
                                            //     width: 30,
                                            //     height: 40,
                                            //     fit: BoxFit.cover,
                                            //   )
                                            //       : Image.memory(
                                            //     base64Decode(customer[
                                            //     index]
                                            //         .gambar_produk_utama!),
                                            //     width: 30,
                                            //     height: 40,
                                            //     fit: BoxFit.cover,
                                            //   )
                                            //       : Image.asset(
                                            //     AppString.defaultImg,
                                            //     width: 30,
                                            //     height: 40,
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            // ),
                                            title: Text(
                                              customer[index].nama_produk!,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text('QTY :' +
                                                customer[index].qty.toString()),
                                            trailing: Text(
                                                'Rp. ${(customer[index].harga_jual_eceran! * customer[index].qty).toString()}'),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              print('min-------------->');
                                              customer[index].qty--;

                                              // Get the individual product values to subtract
                                              final hargaBeliPerItem =
                                                  customer[index]
                                                      .harga_jual_eceran!;
                                              final hppPerItem =
                                                  customer[index].hpp!;

                                              // Subtract from totals
                                              controller.subtotal.value -=
                                                  hargaBeliPerItem;

                                              var sumqty = customer.fold(
                                                  0,
                                                  (sum, item) =>
                                                      sum - (item.qty ?? 0));
                                              controller.totalItem.value =
                                                  sumqty;

                                              if (customer[index].qty <= 0) {
                                                var x =
                                                    customer.removeAt(index);
                                                controller.deletedDetailIds
                                                    .add(x.uuid!);
                                                controller.keranjang.refresh();
                                              }
                                              controller.hitungPembayaran(
                                                  controller.promolistvalue);
                                              controller.keranjang.refresh();
                                            },
                                            icon: Icon(Icons.remove)),
                                        IconButton(
                                            onPressed: () {
                                              customer[index].qty++;
                                              controller.subtotal.value +=
                                                  customer[index]
                                                      .harga_jual_eceran!;
                                              var sumqty = customer.fold(
                                                  0,
                                                  (sum, item) =>
                                                      sum + (item.qty ?? 0));
                                              controller.totalItem.value =
                                                  sumqty;
                                              controller.hitungPembayaran(
                                                  controller.promolistvalue);
                                              controller.keranjang.refresh();
                                            },
                                            icon: Icon(Icons.add))
                                      ],
                                    ),
                                    Container(
                                      height: 0.5,
                                      color: Colors.black,
                                    )
                                  ],
                                );
                              },
                            )
                          : Center(child: Text('Paket kosong')),
                    );
                  }),
                  // Obx(() => Padding(
                  //       padding: AppPading.defaultBodyPadding(),
                  //       child: Container(
                  //         height: 300,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.black, width: 0.5),
                  //         ),
                  //         child: ListView.builder(
                  //           itemCount: controller.keranjang.length,
                  //           itemBuilder: (context, index) {
                  //             final item = controller.keranjang[index];
                  //             return Column(
                  //               children: [
                  //                 ListTile(
                  //                   title: Text(item.nama_produk!),
                  //                   subtitle:
                  //                       Text("Qty x " + item.qty.toString()),
                  //                   trailing: Text(
                  //                     'Rp. ${(item.harga_jual_eceran! * item.qty).toString()}',
                  //                   ),
                  //                 ),
                  //                 const Divider(height: 1, color: Colors.black),
                  //               ],
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     )),
                  Obx(() {
                    return Padding(
                      padding: AppPading.defaultBodyPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total item :'),
                          Text(controller.totalItem.value.toString()),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.defaultBodyPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal :'),
                          Text(controller.subtotal.value.toString()),
                        ],
                      ),
                    );
                  }),
                  // Obx(() => Padding(
                  //       padding: AppPading.defaultBodyPadding(),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               'Diskon?',
                  //               style: AppFont.regular(),
                  //             ),
                  //           ),
                  //           Switch(
                  //             value: controller.diskondisplay.value,
                  //             onChanged: (value) =>
                  //                 controller.diskondisplay.value = value,
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  // Obx(() => controller.diskondisplay.value
                  //     ? Padding(
                  //         padding: AppPading.defaultBodyPadding(),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Expanded(
                  //               child: TextFormField(
                  //                 controller: controller.diskon.value,
                  //                 decoration: InputDecoration(
                  //                   prefixIcon:
                  //                       controller.selecteddiskon.value ==
                  //                               controller.opsidiskon[0]
                  //                           ? const Icon(Icons.money)
                  //                           : const Icon(Icons.percent),
                  //                   labelText: 'Diskon',
                  //                   border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                 ),
                  //                 keyboardType: TextInputType.number,
                  //                 validator: (value) => value!.isEmpty
                  //                     ? 'Diskon harus diisi'
                  //                     : null,
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Obx(
                  //                 () => Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: RadioMenuButton(
                  //                         value: controller.opsidiskon[0],
                  //                         groupValue:
                  //                             controller.selecteddiskon.value,
                  //                         onChanged: (x) {
                  //                           controller.selecteddiskon.value =
                  //                               x!;
                  //                           controller.hitungbesardiskonkasir();
                  //                           controller.totalval();
                  //                         },
                  //                         child: const Text('Rp.'),
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: RadioMenuButton(
                  //                           value: controller.opsidiskon[1],
                  //                           groupValue:
                  //                               controller.selecteddiskon.value,
                  //                           onChanged: (x) {
                  //                             controller.selecteddiskon.value =
                  //                                 x!;
                  //                             controller
                  //                                 .hitungbesardiskonkasir();
                  //                             controller.totalval();
                  //                           },
                  //                           child: const Text('%')),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox.shrink()),

                  Obx(() {
                    return Padding(
                      padding: AppPading.defaultBodyPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'PPN 11% :',
                              style: AppFont.regular(),
                            ),
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              controller.ppnSwitch.value == true
                                  ? Expanded(
                                      child: Text(
                                        "Rp." + controller.ppn.value.toString(),
                                        style: AppFont.regular(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Expanded(
                                      child: Text(
                                        "-",
                                        style: AppFont.regular(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                              Transform.scale(
                                scale: 0.65,
                                child: Switch(
                                    activeColor: AppColor.primary,
                                    value: controller.ppnSwitch.value,
                                    onChanged: (x) {
                                      controller.ppnSwitch.value = x;
                                      print(controller.ppnSwitch);
                                      print(controller.ppn);
                                      controller.hitungPembayaran(
                                          controller.promolistvalue);
                                    }),
                              ),
                            ],
                          )),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.defaultBodyPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  Text('Diskon :', style: AppFont.regular())),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.metode_diskon == 1
                                    ? Text(
                                        controller.displaydiskon
                                                .toStringAsFixed(0) +
                                            '%',
                                        style: AppFont.regular(),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        'Rp. ' +
                                            controller.displaydiskon.value
                                                .toString(),
                                        style: AppFont.regular(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                controller.displaydiskon.value == 0
                                    ? InkWell(
                                        splashColor: AppColor.secondary,
                                        onTap: () {
                                          controller.editDiskonKasir(controller,
                                              controller.promolistvalue);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColor.secondary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ]),
                                          child: Text(
                                            'Diskon',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        splashColor: AppColor.secondary,
                                        onTap: () {
                                          controller.editDiskonKasir(controller,
                                              controller.promolistvalue);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColor.secondary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ]),
                                          child: Text(
                                            'Diskon',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  Obx(() => Padding(
                        padding: AppPading.defaultBodyPadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.promodisplay.value == true
                                ? Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.primary),
                                            child: IconButton(
                                                onPressed: () {
                                                  controller.popAddPromo();
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ))),
                                        Expanded(
                                          child: DropdownButtonFormField2(
                                            key: UniqueKey(),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null &&
                                                  controller
                                                          .promodisplay.value ==
                                                      true) {
                                                return 'Promo harus dipilih';
                                              }
                                              return null;
                                            },
                                            isExpanded: true,
                                            dropdownStyleData:
                                                DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white)),
                                            hint: Text('Promo',
                                                style: AppFont.regular()),
                                            value: controller.promolistvalue,
                                            items: controller.promolist.value
                                                .map((x) {
                                              return DropdownMenuItem(
                                                child: Text(x.namaPromo!),
                                                value: x.uuid,
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              controller.promolistvalue = val;
                                              print(controller.promolistvalue);
                                              controller.hitungPembayaran(
                                                  val.toString());
                                              controller.promo.value.text =
                                                  controller.promolist
                                                      .where(
                                                          (x) => x.uuid == val)
                                                      .first
                                                      .namaPromo!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    'Promo?',
                                    style: AppFont.regular(),
                                  ),
                            Transform.scale(
                              scale: 0.65,
                              child: Switch(
                                  value: controller.promodisplay.value,
                                  onChanged: (value) {
                                    controller.promodisplay.value = value;
                                    print(controller.promodisplay.value);
                                    controller.hitungPembayaran(
                                        controller.promolistvalue);
                                  }),
                            ),
                          ],
                        ),
                      )),

                  // Obx(() => controller.promodisplay.value
                  //     ? Padding(
                  //         padding: AppPading.defaultBodyPadding(),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Expanded(
                  //               child: TextFormField(
                  //                 controller: controller.promo.value,
                  //                 decoration: InputDecoration(
                  //                   labelText: 'Kode promo',
                  //                   border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                 ),
                  //                 keyboardType: TextInputType.text,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox.shrink()),
                ],
              ),
            ),
          ),

          // Fixed bottom menu
          BottomMenuPembayaran(),
        ],
      ),
    );
  }
}
