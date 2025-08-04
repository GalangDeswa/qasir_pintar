class DataPenjualan {
  DataPenjualan(
      {this.id,
      this.uuid,
      this.idToko,
      this.idLogin,
      this.noFaktur,
      this.tanggal,
      this.idPelanggan,
      this.namaPelanggan,
      this.totalQty,
      this.totalDiskon,
      this.subtotal,
      this.diskonPersen,
      this.diskonNominal,
      this.kodePromo,
      this.nilaiPromo,
      this.totalBayar,
      this.nilaiBayar,
      this.kembalian,
      this.sync,
      this.namaPromo,
      this.totalPajak,
      this.reversal,
      this.id_karyawan,
      this.namaKaryawan});

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idLogin;
  final String? noFaktur;
  final String? tanggal; // ISO 8601 format string
  final String? idPelanggan;
  final String? namaPelanggan;
  final int? totalQty;
  final double? totalDiskon;
  final double? subtotal;
  final double? diskonPersen;
  final double? diskonNominal;
  final String? kodePromo;
  final double? nilaiPromo;
  final double? totalBayar;
  final double? nilaiBayar;
  final double? kembalian;
  final String? namaPromo;
  final double? totalPajak;
  final int? sync;
  final int? reversal;
  final String? id_karyawan;
  final String? namaKaryawan; // 0/1 boolean equivalent

  factory DataPenjualan.fromJsondb(Map<String, dynamic> json) {
    return DataPenjualan(
        id: json["id"],
        uuid: json["uuid"],
        idToko: json["id_toko"],
        idLogin: json["id_login"],
        noFaktur: json["no_faktur"],
        tanggal: json["tanggal"],
        idPelanggan: json["id_pelanggan"],
        totalQty: json["total_qty"] ?? 0,
        totalDiskon: json["total_diskon"] ?? 0.0,
        subtotal: json["subtotal"] ?? 0.0,
        diskonPersen: json["diskon_persen"] ?? 0.0,
        diskonNominal: json["diskon_nominal"] ?? 0.0,
        kodePromo: json["kode_promo"],
        nilaiPromo: json["nilai_promo"] ?? 0.0,
        totalBayar: json["total_bayar"] ?? 0.0,
        nilaiBayar: json["nilai_bayar"] ?? 0.0,
        kembalian: json["kembalian"] ?? 0.0,
        sync: json["sync"],
        namaPelanggan: json["nama_pelanggan"],
        namaPromo: json["nama_promo"],
        totalPajak: json["total_pajak"] ?? 0.0,
        reversal: json["reversal"],
        id_karyawan: json["id_karyawan"],
        namaKaryawan: json["nama_karyawan"]);
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['id_login'] = idLogin;
    map['no_faktur'] = noFaktur;
    map['tanggal'] = tanggal;
    map['id_pelanggan'] = idPelanggan;
    map['total_qty'] = totalQty;
    map['total_diskon'] = totalDiskon;
    map['subtotal'] = subtotal;
    map['diskon_persen'] = diskonPersen;
    map['diskon_nominal'] = diskonNominal;
    map['kode_promo'] = kodePromo;
    map['nilai_promo'] = nilaiPromo;
    map['total_bayar'] = totalBayar;
    map['nilai_bayar'] = nilaiBayar;
    map['kembalian'] = kembalian;
    map['sync'] = sync;
    map['total_pajak'] = totalPajak;
    map['id_karyawan'] = id_karyawan;
    map['reversal'] = reversal;
    return map;
  }
}

class DataDetailPenjualan {
  DataDetailPenjualan(
      {this.id,
      this.uuid,
      this.idToko,
      this.idPenjualan,
      this.idProduk,
      this.idPaket,
      this.namaPaket,
      this.qty,
      this.subtotal,
      this.subtotalPaket,
      this.discPersen,
      this.discNominal,
      this.totalHarga,
      this.sync,
      this.harga_jual_eceran,
      this.nama_produk});

  final int? id;
  final String? uuid;
  final String? idPaket;
  final String? namaPaket;
  final String? idToko;
  final String? idPenjualan;
  final String? idProduk;
  final int? qty;
  final double? subtotal;
  final double? subtotalPaket;
  final double? discPersen;
  final double? discNominal;
  final double? totalHarga;
  final int? sync; // 0/1 boolean equivalent
  final String? nama_produk;
  final double? harga_jual_eceran;

  factory DataDetailPenjualan.fromJsondb(Map<String, dynamic> json) {
    return DataDetailPenjualan(
      id: json["id"],
      uuid: json["uuid"],
      idToko: json["id_toko"],
      idPenjualan: json["id_penjualan"],
      idProduk: json["id_produk"],
      idPaket: json['id_paket'],
      qty: json["qty"] ?? 0,
      subtotal: json["subtotal"] ?? 0.0,
      subtotalPaket: json["subtotal_paket"] ?? 0.0,
      discPersen: json["disc_persen"] ?? 0.0,
      discNominal: json["disc_nominal"] ?? 0.0,
      totalHarga: json["total_harga"] ?? 0.0,
      sync: json["sync"],
      nama_produk: json["nama_produk"],
      namaPaket: json["nama_paket"],
      harga_jual_eceran: json["harga_jual_eceran"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['id_penjualan'] = idPenjualan;
    map['id_produk'] = idProduk;
    map['id_paket'] = idPaket;
    map['qty'] = qty;
    map['subtotal'] = subtotal;
    map['subtotal_paket'] = subtotalPaket;
    map['disc_persen'] = discPersen;
    map['disc_nominal'] = discNominal;
    map['total_harga'] = totalHarga;
    map['sync'] = sync;
    return map;
  }
}

class PenjualanItem {
  final String noFaktur;
  final int reversal; // ← add this
  final String uuidPenjualan;
  final String tanggal; // e.g. "2025-05-17"
  final double totalBayar; // e.g. 50000.0
  final int
      totalqty; // we’ll hard‐code “Tunai” for now (or add it to DataPenjualan if you want)

  PenjualanItem({
    required this.uuidPenjualan,
    required this.noFaktur,
    required this.tanggal,
    required this.totalBayar,
    required this.totalqty,
    required this.reversal,
  });

  /// Convert from your existing DB‐map.
  factory PenjualanItem.fromDataPenjualan(DataPenjualan dp) {
    return PenjualanItem(
      reversal: dp.reversal!, // ← convert to bool
      noFaktur: dp.noFaktur ?? '—',
      tanggal: dp.tanggal ?? '',
      totalBayar: dp.totalBayar ?? 0.0,
      totalqty: dp.totalQty!,
      uuidPenjualan:
          dp.uuid!, // if you later add a "metode" field, replace this
    );
  }
}

class DataPenjualanByDate {
  final String date; // e.g. "2025-05-17"
  final int totalForDate; // e.g. 105000
  final List<PenjualanItem>
      items; // all transactions that happened on that date

  DataPenjualanByDate({
    required this.date,
    required this.totalForDate,
    required this.items,
  });
}
