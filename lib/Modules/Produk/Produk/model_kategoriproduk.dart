class DataKategoriProduk {
  DataKategoriProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.ikon,
    this.namakelompok,
    this.aktif,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final dynamic id_toko;
  final dynamic ikon;
  final String? namakelompok;
  final int? aktif;
  final String? sync;

  factory DataKategoriProduk.fromJsondb(Map<String, dynamic> json) {
    return DataKategoriProduk(
        id: json["id"],
        uuid: json['uuid'],
        namakelompok: json["Nama_Kelompok"],
        sync: json["sync"],
        id_toko: json["id_toko"],
        aktif: json["Aktif"],
        ikon: json["Ikon"] ?? '-');
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['Nama_Kelompok'] = namakelompok;
    map['Ikon'] = ikon;
    map['Aktif'] = aktif;
    map['sync'] = sync;
    return map;
  }
}
