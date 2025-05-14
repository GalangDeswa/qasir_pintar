class DataPromo {
  DataPromo({
    this.id,
    this.uuid,
    this.idToko,
    this.namaPromo,
    this.promoPersen,
    this.promoNominal,
    this.tglMulai,
    this.tglSelesai,
    this.keterangan,
    this.aktif,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final String? idToko;
  final String? namaPromo;
  final double? promoPersen;
  final double? promoNominal;
  final String? tglMulai; // ISO 8601 format string
  final String? tglSelesai; // ISO 8601 format string
  final String? keterangan;
  final int? aktif; // 0/1 boolean equivalent
  final int? sync; // 0/1 boolean equivalent

  factory DataPromo.fromJsondb(Map<String, dynamic> json) {
    return DataPromo(
      id: json["id"],
      uuid: json["uuid"],
      idToko: json["id_toko"],
      namaPromo: json["nama_promo"],
      promoPersen: json["promo_persen"] ?? 0.0,
      promoNominal: json["promo_nominal"] ?? 0.0,
      tglMulai: json["tgl_mulai"],
      tglSelesai: json["tgl_selesai"],
      keterangan: json["keterangan"],
      aktif: json["aktif"] ?? 0,
      sync: json["sync"] ?? 0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['nama_promo'] = namaPromo;
    map['promo_persen'] = promoPersen;
    map['promo_nominal'] = promoNominal;
    map['tgl_mulai'] = tglMulai;
    map['tgl_selesai'] = tglSelesai;
    map['keterangan'] = keterangan;
    map['aktif'] = aktif;
    map['sync'] = sync;
    return map;
  }
}
