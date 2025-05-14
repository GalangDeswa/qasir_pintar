class DataPenerimaanProduk {
  DataPenerimaanProduk({
    this.id,
    this.uuid,
    this.idToko,
    this.idSupplier,
    this.tanggal,
    this.idLogin,
    this.nomorFaktur,
    this.jenisPenerimaan,
    this.jumlahQty,
    this.totalHarga,
    this.ongkosKirim,
    this.totalBayar,
    this.sync,
    this.jumlahBayar,
    this.sisaBayar,
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idSupplier;
  final String? tanggal; // ISO 8601 format string
  final String? idLogin;
  final String? nomorFaktur;
  final String? jenisPenerimaan;
  final int? jumlahQty;
  final double? totalHarga;
  final double? ongkosKirim;
  final double? totalBayar;
  final int? sync; // 0/1 boolean equivalent
  final double? jumlahBayar;
  final double? sisaBayar;

  factory DataPenerimaanProduk.fromJsondb(Map<String, dynamic> json) {
    return DataPenerimaanProduk(
      id: json["id"],
      uuid: json["uuid"],
      idToko: json["id_toko"],
      idSupplier: json["id_supplier"],
      tanggal: json["tanggal"],
      idLogin: json["id_login"],
      nomorFaktur: json["nomor_faktur"],
      jenisPenerimaan: json["jenis_penerimaan"],
      jumlahQty: json["jumlah_qty"] ?? 0,
      totalHarga: json["total_harga"] ?? 0.0,
      ongkosKirim: json["ongkos_kirim"] ?? 0.0,
      totalBayar: json["total_bayar"] ?? 0.0,
      sync: json["sync"],
      jumlahBayar: json["jumlah_bayar"] ?? 0.0,
      sisaBayar: json["sisa_bayar"] ?? 0.0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['id_supplier'] = idSupplier;
    map['tanggal'] = tanggal;
    map['id_login'] = idLogin;
    map['nomor_faktur'] = nomorFaktur;
    map['jenis_penerimaan'] = jenisPenerimaan;
    map['jumlah_qty'] = jumlahQty;
    map['total_harga'] = totalHarga;
    map['ongkos_kirim'] = ongkosKirim;
    map['total_bayar'] = totalBayar;
    map['sync'] = sync;
    map['jumlah_bayar'] = jumlahBayar;
    map['sisa_bayar'] = sisaBayar;
    return map;
  }
}

class DataDetailPenerimaanProduk {
  DataDetailPenerimaanProduk({
    this.id,
    this.uuid,
    this.idToko,
    this.idPenerimaan,
    this.idProduk,
    this.qty,
    this.subtotal,
    this.nama_produk,
    this.harga_eceran,
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idPenerimaan;
  final String? idProduk;
  final int? qty;
  final double? subtotal;
  final String? nama_produk;
  final double? harga_eceran;

  factory DataDetailPenerimaanProduk.fromJsondb(Map<String, dynamic> json) {
    return DataDetailPenerimaanProduk(
      id: json["id"],
      uuid: json["uuid"],
      idToko: json["id_toko"],
      idPenerimaan: json["id_penerimaan"],
      idProduk: json["id_produk"],
      qty: json["qty"] ?? 0,
      subtotal: json["subtotal"] ?? 0.0,
      nama_produk: json["nama_produk"],
      harga_eceran: json["harga_eceran"] ?? 0.0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['id_penerimaan'] = idPenerimaan;
    map['id_produk'] = idProduk;
    map['qty'] = qty;
    map['subtotal'] = subtotal;
    return map;
  }
}
