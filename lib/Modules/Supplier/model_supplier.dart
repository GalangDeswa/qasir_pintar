class DataSupplier {
  DataSupplier(
      {this.id,
      this.uuid,
      this.id_toko,
      this.nama_supplier,
      this.nohp,
      this.alamat,
      this.aktif,
      this.sync});

  final int? id;
  final String? uuid;
  final dynamic id_toko;
  final String? nama_supplier;
  final nohp;
  final alamat;
  final int? aktif;
  final String? sync;

  factory DataSupplier.fromJsondb(Map<String, dynamic> json) {
    return DataSupplier(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      nama_supplier: json["Nama_Supplier"],
      nohp: json["No_Telp"],
      alamat: json["Alamat"],
      aktif: json["Aktif"],
      sync: json["sync"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['Nama_Supplier'] = nama_supplier;
    map['No_Telp'] = nohp;
    map['Alamat'] = alamat;
    map['Aktif'] = aktif;
    map['sync'] = sync;
    return map;
  }
}
