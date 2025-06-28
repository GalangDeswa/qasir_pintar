import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qasir_pintar/Config/config.dart';

import '../../../../Widget/widget.dart';
import 'controller_addproduk.dart';

// class TambahGambarProduk extends GetView<TambahProdukController> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Gambar Produk'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: controller.formKey,
//           child: Column(
//             children: [
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TextFormField(
//                     controller: controller.id.value,
//                     decoration: InputDecoration(
//                       labelText: 'ID',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'ID harus diisi';
//                       }
//                       return null;
//                     },
//                   ),
//                 );
//               }),
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TextFormField(
//                     controller: controller.uuid.value,
//                     decoration: InputDecoration(
//                       labelText: 'UUID',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'UUID harus diisi';
//                       }
//                       return null;
//                     },
//                   ),
//                 );
//               }),
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TextFormField(
//                     controller: controller.idToko.value,
//                     decoration: InputDecoration(
//                       labelText: 'ID Toko',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'ID Toko harus diisi';
//                       }
//                       return null;
//                     },
//                   ),
//                 );
//               }),
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TextFormField(
//                     controller: controller.idProduk.value,
//                     decoration: InputDecoration(
//                       labelText: 'ID Produk',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'ID Produk harus diisi';
//                       }
//                       return null;
//                     },
//                   ),
//                 );
//               }),
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: TextFormField(
//                     controller: controller.gambar.value,
//                     decoration: InputDecoration(
//                       labelText: 'Gambar URL',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Gambar URL harus diisi';
//                       }
//                       return null;
//                     },
//                   ),
//                 );
//               }),
//               Obx(() {
//                 return SwitchListTile(
//                   title: Text('Aktif'),
//                   value: controller.aktif.value,
//                   onChanged: (bool value) {
//                     controller.aktif.value = value;
//                   },
//                 );
//               }),
//               ElevatedButton(
//                 onPressed: () {
//                   if (controller.formKey.currentState!.validate()) {
//                     controller.tambahGambarProduk();
//                   }
//                 },
//                 child: Text('Tambah'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TambahHargaJualProduk extends GetView<TambahProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Harga Jual Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.registerKey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.jenistransaksi.value,
                    decoration: InputDecoration(
                      labelText: 'Jenis Transaksi',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jenis Transaksi harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.hargaJual.value,
                    decoration: InputDecoration(
                      labelText: 'Harga Jual',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harga Jual harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              ElevatedButton(
                onPressed: () {
                  if (controller.registerKey.value.currentState!.validate()) {
                    // controller.tambahHargaJualProduk();
                  }
                },
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TambahSatuanProduk extends GetView<TambahProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Satuan Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.registerKey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.namaSatuan.value,
                    decoration: InputDecoration(
                      labelText: 'Nama Satuan',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama Satuan harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.isiPerSatuan.value,
                    decoration: InputDecoration(
                      labelText: 'Isi Per Satuan',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Isi Per Satuan harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.hargaPerSatuan.value,
                    decoration: InputDecoration(
                      labelText: 'Harga Per Satuan',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harga Per Satuan harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              ElevatedButton(
                onPressed: () {
                  if (controller.registerKey.value.currentState!.validate()) {
                    controller.tambahSatuanProduk();
                  }
                },
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TambahPajakProduk extends GetView<TambahProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Tambah pajak', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Form(
          key: controller.pajakkey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.namaPajak.value,
                    decoration: InputDecoration(
                      labelText: 'Nama Pajak',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama Pajak harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.nominalPajak.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.percent),
                      labelText: 'Nominal Pajak',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nominal Pajak harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              button_solid_custom(
                  onPressed: () {
                    if (controller.pajakkey.value.currentState!.validate()) {
                      controller.tambahPajak();
                    }
                  },
                  child: Text('tambah'),
                  width: context.res_width)
            ],
          ),
        ),
      ),
    );
  }
}

class TambahUkuranProduk extends GetView<TambahProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Tambah ukuran', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Form(
          key: controller.ukurankey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.ukuranProduk.value,
                    decoration: InputDecoration(
                      labelText: 'Ukuran',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ukuran harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              button_solid_custom(
                  onPressed: () {
                    if (controller.ukurankey.value.currentState!.validate()) {
                      controller.tambahUkuranProduk();
                    }
                  },
                  child: Text('Tambah'),
                  width: context.res_width)
            ],
          ),
        ),
      ),
    );
  }
}
