class DataBeban {
  DataBeban({
    this.id,
    this.uuid,
    this.idToko,
    this.idKategoriBeban,
    this.idKaryawan,
    this.namaBeban,
    this.jumlahBeban,
    this.tanggalBeban,
    this.aktif,
    this.sync,
    this.kategoriBeban,
    this.keterangan,
    this.namaKaryawan,
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? idKategoriBeban;
  final String? idKaryawan;
  final String? namaBeban;
  final double? jumlahBeban;
  final String? tanggalBeban;
  final int? aktif;
  final int? sync;
  final String? kategoriBeban;
  final String? keterangan;
  final String? namaKaryawan;

  factory DataBeban.fromJsondb(Map<String, dynamic> json) {
    return DataBeban(
      id: json['id'],
      uuid: json['uuid'],
      idToko: json['id_toko'],
      idKategoriBeban: json['id_kategori_beban'],
      idKaryawan: json['id_karyawan'],
      namaBeban: json['nama_beban'],
      jumlahBeban: (json['jumlah_beban'] as num?)?.toDouble() ?? 0.0,
      tanggalBeban: json['tanggal_beban'],
      aktif: json['aktif'],
      sync: json['sync'],
      kategoriBeban: json['kategori_beban'],
      keterangan: json['keterangan'],
      namaKaryawan: json['nama_karyawan'],
    );
  }

  Map<String, dynamic> DB() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['id_kategori_beban'] = idKategoriBeban;
    map['id_karyawan'] = idKaryawan;
    map['nama_beban'] = namaBeban;
    map['jumlah_beban'] = jumlahBeban;
    map['tanggal_beban'] = tanggalBeban;
    map['aktif'] = aktif;
    map['sync'] = sync;
    map['keterangan'] = keterangan;
    return map;
  }
}

class DataKategoriBeban {
  DataKategoriBeban({
    this.id,
    this.uuid,
    this.idToko,
    this.namaKategoriBeban,
    this.aktif,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? namaKategoriBeban;
  final int? aktif;
  final int? sync;

  factory DataKategoriBeban.fromJsondb(Map<String, dynamic> json) {
    return DataKategoriBeban(
      id: json['id'],
      uuid: json['uuid'],
      idToko: json['id_toko'],
      namaKategoriBeban: json['nama_kategori_beban'],
      aktif: json['aktif'],
      sync: json['sync'],
    );
  }

  Map<String, dynamic> DB() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['nama_kategori_beban'] = namaKategoriBeban;
    map['aktif'] = aktif;
    map['sync'] = sync;
    return map;
  }
}
