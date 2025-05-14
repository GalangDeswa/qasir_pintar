class DataKategoriPelanggan {
  DataKategoriPelanggan({
    this.id,
    this.uuid,
    this.id_toko,
    this.ikon,
    this.kategori,
    this.status,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final dynamic id_toko;
  final dynamic ikon;
  final String? kategori;
  final int? status;
  final String? sync;

  factory DataKategoriPelanggan.fromJsondb(Map<String, dynamic> json) {
    return DataKategoriPelanggan(
        id: json["id"],
        uuid: json['uuid'],
        kategori: json["kategori"],
        sync: json["sync"],
        id_toko: json["id_toko"],
        status: json["aktif"],
        ikon: json["ikon"] ?? '-');
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['kategori'] = kategori;
    map['ikon'] = ikon;
    map['aktif'] = status;
    map['sync'] = sync;
    return map;
  }
}
