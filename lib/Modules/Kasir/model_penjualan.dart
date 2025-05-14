class DataPenjualan {
  DataPenjualan({
    this.id,
    this.uuid,
    this.idToko,
    this.idLogin,
    this.noFaktur,
    this.tanggal,
    this.idPelanggan,
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
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idLogin;
  final String? noFaktur;
  final String? tanggal; // ISO 8601 format string
  final String? idPelanggan;
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
  final int? sync; // 0/1 boolean equivalent

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
    );
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
      this.qty,
      this.subtotal,
      this.discPersen,
      this.discNominal,
      this.totalHarga,
      this.sync,
      this.harga_jual_eceran,
      this.nama_produk});

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idPenjualan;
  final String? idProduk;
  final int? qty;
  final double? subtotal;
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
      qty: json["qty"] ?? 0,
      subtotal: json["subtotal"] ?? 0.0,
      discPersen: json["disc_persen"] ?? 0.0,
      discNominal: json["disc_nominal"] ?? 0.0,
      totalHarga: json["total_harga"] ?? 0.0,
      sync: json["sync"],
      nama_produk: json["nama_produk"],
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
    map['qty'] = qty;
    map['subtotal'] = subtotal;
    map['disc_persen'] = discPersen;
    map['disc_nominal'] = discNominal;
    map['total_harga'] = totalHarga;
    map['sync'] = sync;
    return map;
  }
}
