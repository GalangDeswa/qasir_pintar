class DataSubKategoriProduk {
  DataSubKategoriProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_kelompok_produk,
    this.namaSubkelompok,
    this.sync,
    this.namakategori,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final dynamic id_toko;
  final dynamic id_kelompok_produk;
  final String? namaSubkelompok;
  final namakategori;
  final int? aktif;
  final String? sync;

  factory DataSubKategoriProduk.fromJsondb(Map<String, dynamic> json) {
    return DataSubKategoriProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_kelompok_produk: json['ID_Kelompok_Produk'],
      namaSubkelompok: json["Nama_Sub_Kelompok"],
      sync: json["sync"],
      id_toko: json["id_toko"],
      namakategori: json['kategori_nama'],
      aktif: json["aktif"],
      // ikon: json["Ikon"] ?? '-'
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['Nama_Sub_Kelompok'] = namaSubkelompok;
    map['ID_Kelompok_Produk'] = id_kelompok_produk;
    map['aktif'] = aktif;
    map['sync'] = sync;
    return map;
  }
}
