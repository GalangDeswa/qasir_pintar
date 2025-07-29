class DataKaryawan {
  DataKaryawan({
    this.id,
    this.uuid,
    this.id_toko,
    this.nama_karyawan,
    this.nohp,
    this.email,
    this.aktif,
    this.pin,
    this.sync,
    this.role,
  });

  final int? id;
  final String? uuid;
  final dynamic id_toko;
  final String? nama_karyawan;
  final nohp;
  final email;
  final aktif;
  final pin;
  final String? sync;
  final String? role;

  factory DataKaryawan.fromJsondb(Map<String, dynamic> json) {
    return DataKaryawan(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      nama_karyawan: json["Nama_Karyawan"],
      nohp: json["No_Telp"],
      email: json["Email"],
      pin: json['Pin'],
      aktif: json["Aktif"],
      sync: json["sync"],
      role: json["role"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['Nama_Karyawan'] = nama_karyawan;
    map['No_Telp'] = nohp;
    map['Email'] = email;
    map['Pin'] = pin;
    map['Aktif'] = aktif;
    map['sync'] = sync;
    map['role'] = role;
    return map;
  }
}
