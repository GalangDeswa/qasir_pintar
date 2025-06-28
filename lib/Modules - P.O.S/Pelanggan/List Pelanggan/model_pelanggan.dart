class DataPelanggan {
  DataPelanggan({
    this.id,
    this.uuid,
    this.idToko,
    this.idKategori,
    this.noHp,
    this.namaPelanggan,
    this.tglLahir,
    this.email,
    this.foto,
    this.alamat,
    this.statusPelanggan,
    this.kategoriNama,
    this.sync,
  });

  final int? id;
  final String? uuid;
  final dynamic idToko;
  final idKategori;
  final String? noHp;
  final String? namaPelanggan;
  final String? tglLahir;
  final String? email;
  final String? foto;
  final dynamic alamat;
  final statusPelanggan;
  final dynamic kategoriNama;
  final String? sync;

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = idToko;
    map['ID_Kategori'] = idKategori;
    map['No_HP'] = noHp;
    map['Nama_Pelanggan'] = namaPelanggan;
    map['Tgl_Lahir'] = tglLahir;
    map['Email'] = email;
    map['Foto'] = foto;
    map['Alamat'] = alamat;
    map['Aktif'] = statusPelanggan;
    map['sync'] = sync;
    return map;
  }

  factory DataPelanggan.fromJsondb(Map<String, dynamic> json) {
    return DataPelanggan(
        id: json['id'],
        uuid: json['uuid'],
        idToko: json['id_toko'],
        idKategori: json['ID_Kategori'],
        noHp: json['No_HP'],
        namaPelanggan: json['Nama_Pelanggan'],
        tglLahir: json['Tgl_Lahir'],
        email: json['Email'],
        foto: json['Foto'] ?? '-',
        alamat: json['Alamat'],
        statusPelanggan: json['Aktif'],
        sync: json['sync'],
        kategoriNama: json['kategori_nama'] ?? '-');
  }
}
