class DataKategoriToko {
  DataKategoriToko({
    this.id,
    this.uuid,
    this.nama,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final String? nama;
  final String? sync;

  factory DataKategoriToko.fromJsondb(Map<String, dynamic> json) {
    return DataKategoriToko(
      id: json["id"],
      uuid: json['uuid'],
      nama: json["nama"],
      sync: json["sync"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['nama'] = nama;
    map['sync'] = sync;
    return map;
  }
}
