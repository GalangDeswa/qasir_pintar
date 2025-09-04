import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qasir_pintar/Config/config.dart';

import '../../../../Widget/widget.dart';
import 'controller_addproduk.dart';

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
              customTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama pajak harus disini';
                    }
                    return null;
                  },
                  controller: controller.namaPajak.value,
                  keyboardType: TextInputType.text,
                  labelText: 'Nama pajak'),
              customTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'nominal pajak harus disini';
                    }
                    if (double.tryParse(value) == null) {
                      return 'nominal pajak harus angka';
                    }
                    if (double.parse(value) <= 0) {
                      return 'nominal pajak harus lebih dari 0';
                    }
                    if (double.parse(value) > 100) {
                      return 'nominal pajak harus kurang dari 100';
                    }

                    return null;
                  },
                  controller: controller.nominalPajak.value,
                  hintText: '10%',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(Icons.percent),
                  labelText: 'Nominal pajak'),
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
              customTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ukuran harus disini';
                    }
                    return null;
                  },
                  controller: controller.ukuranProduk.value,
                  labelText: 'Ukuran'),
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
