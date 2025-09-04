class DataProdukApi {
  DataProdukApi({
    this.id,
    this.userId,
    this.group,
    this.unit,
    this.name,
    this.value,
    this.fund,
    this.buy,
    this.sell,
    this.picture,
    this.status,
    this.createdAt,
    this.sync,
  });

  final int? id;
  final int? userId;
  final String? group;
  final String? unit;
  final String? name;
  final int? value;
  final double? fund;
  final double? buy;
  final double? sell;
  final String? picture;
  final int? status;
  final String? createdAt;
  final int? sync;

  /// from database json/map
  factory DataProdukApi.fromJsondb(Map<String, dynamic> json) {
    return DataProdukApi(
      id: json['id'],
      userId: json['user_id'],
      group: json['group'],
      unit: json['unit'],
      name: json['name'],
      value: json['value'],
      fund: json['fund'] != null ? (json['fund'] as num).toDouble() : null,
      buy: json['buy'] != null ? (json['buy'] as num).toDouble() : null,
      sell: json['sell'] != null ? (json['sell'] as num).toDouble() : null,
      picture: json['picture'],
      status: json['status'],
      createdAt: json['created_at'],
      sync: json['sync'],
    );
  }

  /// to Map for database insert/update
  Map<String, dynamic> DB() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['group'] = group;
    map['unit'] = unit;
    map['name'] = name;
    map['value'] = value;
    map['fund'] = fund;
    map['buy'] = buy;
    map['sell'] = sell;
    map['picture'] = picture;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['sync'] = sync;
    return map;
  }
}

class DataProdukApiCart {
  DataProdukApiCart({
    this.id,
    this.userId,
    this.group,
    this.unit,
    this.name,
    this.value,
    this.fund,
    this.buy,
    this.sell,
    this.picture,
    this.status,
    this.createdAt,
    this.sync,
    required this.qty,
  });

  final int? id;
  final int? userId;
  final String? group;
  final String? unit;
  final String? name;
  final int? value;
  final double? fund;
  final double? buy;
  final double? sell;
  final String? picture;
  final int? status;
  final String? createdAt;
  final int? sync;
  int qty = 0;

  /// from database json/map
  factory DataProdukApiCart.fromJsondb(Map<String, dynamic> json) {
    return DataProdukApiCart(
      id: json['id'],
      userId: json['user_id'],
      group: json['group'],
      unit: json['unit'],
      name: json['name'],
      value: json['value'],
      fund: json['fund'] != null ? (json['fund'] as num).toDouble() : null,
      buy: json['buy'] != null ? (json['buy'] as num).toDouble() : null,
      sell: json['sell'] != null ? (json['sell'] as num).toDouble() : null,
      picture: json['picture'],
      status: json['status'],
      createdAt: json['created_at'],
      sync: json['sync'],
      qty: json['qty'], // optional if you want to track local sync status
    );
  }

  /// to Map for database insert/update
  Map<String, dynamic> DB() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['group'] = group;
    map['unit'] = unit;
    map['name'] = name;
    map['value'] = value;
    map['fund'] = fund;
    map['buy'] = buy;
    map['sell'] = sell;
    map['picture'] = picture;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['sync'] = sync;
    return map;
  }
}

class DataProduk {
  DataProduk(
      {this.id,
      this.uuid,
      this.id_toko,
      this.id_kelompok_produk,
      this.id_sub_kelompok_produk,
      this.gambar_produk_utama,
      this.kode_produk,
      this.nama_produk,
      this.serial_key,
      this.imei,
      this.hitung_stok,
      this.tampilkan_di_produk,
      this.harga_beli,
      this.hpp,
      this.harga_jual_grosir,
      this.harga_jual_eceran,
      this.satuan_utama,
      this.isi_dalam_satuan,
      this.pajak,
      this.info_stok_habis,
      this.warna,
      this.ukuran,
      this.berat,
      this.volume_panjang,
      this.volume_lebar,
      this.volume_tinggi,
      this.id_gambar,
      this.id_harga_jual,
      this.id_satuan,
      this.namaKategori,
      this.namasubKategori,
      this.namaPajak,
      this.namaukuran,
      this.harga_jual_pelanggan,
      this.jenisProduk,
      this.stockawal,
      this.qty,
      this.diskon,
      this.nominalpajak});

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_kelompok_produk;
  final String? id_sub_kelompok_produk;
  dynamic gambar_produk_utama;
  final String? kode_produk;
  final String? nama_produk;
  final String? serial_key;
  final String? imei;
  final int? hitung_stok;
  final int? tampilkan_di_produk;
  final double? harga_beli;
  final double? hpp;
  final double? harga_jual_grosir;
  final double? harga_jual_eceran;
  final double? harga_jual_pelanggan;
  final String? satuan_utama;
  final int? isi_dalam_satuan;
  final String? pajak;
  final int? info_stok_habis;
  final String? warna;
  final String? ukuran;
  final double? berat;
  final double? volume_panjang;
  final double? volume_lebar;
  final double? volume_tinggi;
  final String? id_gambar;
  final String? id_harga_jual;
  final String? id_satuan;
  final String? namaKategori;
  final String? namasubKategori;
  final String? namaPajak;
  final double? nominalpajak;
  final String? namaukuran;
  final String? jenisProduk;
  final int? stockawal;
  final int? qty;
  final double? diskon;

  factory DataProduk.fromJsondb(Map<String, dynamic> json) {
    return DataProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_kelompok_produk: json["id_kelompok_produk"],
      id_sub_kelompok_produk: json["id_sub_kelompok_produk"],
      gambar_produk_utama: json["gambar_produk_utama"],
      kode_produk: json["kode_produk"],
      nama_produk: json["nama_produk"],
      serial_key: json["serial_key"],
      imei: json["imei"],
      hitung_stok: json["hitung_stok"],
      tampilkan_di_produk: json["tampilkan_di_produk"],
      harga_beli: json["harga_beli"] ?? 0,
      hpp: json["hpp"] ?? 0,
      harga_jual_grosir: json["harga_jual_grosir"] ?? 0,
      harga_jual_eceran: json["harga_jual_eceran"] ?? 0,
      satuan_utama: json["satuan_utama"],
      isi_dalam_satuan: json["isi_dalam_satuan"] ?? 0,
      pajak: json["pajak"],
      info_stok_habis: json["info_stok_habis"] ?? 0,
      warna: json["warna"],
      ukuran: json["ukuran"],
      berat: json["berat"],
      volume_panjang: json["volume_panjang"],
      volume_lebar: json["volume_lebar"],
      volume_tinggi: json["volume_tinggi"],
      id_gambar: json["id_gambar"],
      id_harga_jual: json["id_harga_jual"],
      id_satuan: json["id_satuan"],
      namaPajak: json["nama_pajak"],
      namaukuran: json["nama_ukuran"],
      namaKategori: json["nama_kategori"],
      namasubKategori: json["nama_subkategori"],
      harga_jual_pelanggan: json["harga_jual_pelanggan"] ?? 0,
      jenisProduk: json["jenis_produk"],
      nominalpajak: json["nominal_pajak"] ?? 0.0,
      stockawal: json["stock_awal"],
      qty: json["qty"],
      diskon: json["diskon"] ?? 0.0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_kelompok_produk'] = id_kelompok_produk;
    map['id_sub_kelompok_produk'] = id_sub_kelompok_produk;
    map['gambar_produk_utama'] = gambar_produk_utama;
    map['kode_produk'] = kode_produk;
    map['nama_produk'] = nama_produk;
    map['serial_key'] = serial_key;
    map['imei'] = imei;
    map['hitung_stok'] = hitung_stok;
    map['tampilkan_di_produk'] = tampilkan_di_produk;
    map['harga_beli'] = harga_beli;
    map['hpp'] = hpp;
    map['harga_jual_grosir'] = harga_jual_grosir;
    map['harga_jual_eceran'] = harga_jual_eceran;
    map['satuan_utama'] = satuan_utama;
    map['isi_dalam_satuan'] = isi_dalam_satuan;
    map['pajak'] = pajak;
    map['info_stok_habis'] = info_stok_habis;
    map['warna'] = warna;
    map['ukuran'] = ukuran;
    map['berat'] = berat;
    map['volume_panjang'] = volume_panjang;
    map['volume_lebar'] = volume_lebar;
    map['volume_tinggi'] = volume_tinggi;
    map['id_gambar'] = id_gambar;
    map['id_harga_jual'] = id_harga_jual;
    map['id_satuan'] = id_satuan;
    map['harga_jual_pelanggan'] = harga_jual_pelanggan;
    map['jenis_produk'] = jenisProduk;
    map['stock_awal'] = stockawal;
    map['diskon'] = diskon;
    return map;
  }
}

class DataKeranjang {
  final String uuid;
  final String idToko;
  int qty;
  final String? pajak;
  final double? hpp;
  final double? nominalpajak;
  final String? namaPajak;
  final String? idPaket;
  final dynamic gambar;

  // Product-specific fields
  final String? namaProduk;
  final double? hargaEceran;

  // Package-specific fields
  final String? namaPaket;
  final double? hargaPaket;

  final bool isPaket;

  DataKeranjang({
    required this.uuid,
    required this.idToko,
    this.qty = 1,
    this.idPaket,
    this.pajak,
    this.hpp,
    this.nominalpajak,
    this.namaPajak,
    this.gambar,
    // Product
    this.namaProduk,
    this.hargaEceran,
    // Package
    this.namaPaket,
    this.hargaPaket,
    required this.isPaket,
  });

  // Helper getter for display name
  String get displayName => isPaket ? namaPaket! : namaProduk!;

  // Helper getter for price
  double get price => isPaket ? hargaPaket! : hargaEceran!;
}

class DataKeranjangSavev2 {
  // final String uuid;
  final DateTime savedAt;
  final String idToko;
  final double diskon;
  final double promoValue;
  final String namaPromo;
  var promoUUID;
  final String customerName;
  final String customerUUID;
  final int metodeDiskon;
  final double displayDiskon;
  final List<DataKeranjang> item;

  DataKeranjangSavev2({
    required this.idToko,
    required this.savedAt,
    required this.item,
    required this.diskon,
    required this.promoValue,
    required this.namaPromo,
    this.promoUUID,
    required this.customerName,
    required this.customerUUID,
    required this.metodeDiskon,
    required this.displayDiskon,
  });
}

class DataProdukTemp {
  DataProdukTemp(
      {this.id,
      this.uuid,
      this.id_toko,
      this.id_kelompok_produk,
      this.id_sub_kelompok_produk,
      this.gambar_produk_utama,
      this.kode_produk,
      this.nama_produk,
      this.serial_key,
      this.imei,
      this.hitung_stok,
      this.tampilkan_di_produk,
      this.harga_beli,
      this.hpp,
      this.harga_jual_grosir,
      this.harga_jual_eceran,
      this.satuan_utama,
      this.isi_dalam_satuan,
      this.pajak,
      this.info_stok_habis,
      this.warna,
      this.ukuran,
      this.berat,
      this.volume_panjang,
      this.volume_lebar,
      this.volume_tinggi,
      this.id_gambar,
      this.id_harga_jual,
      this.id_satuan,
      this.namaKategori,
      this.namasubKategori,
      this.namaPajak,
      this.namaukuran,
      this.harga_jual_pelanggan,
      this.jenisProduk,
      this.stockawal,
      this.diskon,
      required this.qty,
      this.nominalpajak});

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_kelompok_produk;
  final String? id_sub_kelompok_produk;
  dynamic gambar_produk_utama;
  final String? kode_produk;
  final String? nama_produk;
  final String? serial_key;
  final String? imei;
  final int? hitung_stok;
  final int? tampilkan_di_produk;
  final double? harga_beli;
  final double? hpp;
  final double? harga_jual_grosir;
  final double? harga_jual_eceran;
  final double? harga_jual_pelanggan;
  final String? satuan_utama;
  final int? isi_dalam_satuan;
  final String? pajak;
  final int? info_stok_habis;
  final String? warna;
  final String? ukuran;
  final double? berat;
  final double? volume_panjang;
  final double? volume_lebar;
  final double? volume_tinggi;
  final String? id_gambar;
  final String? id_harga_jual;
  final String? id_satuan;
  final String? namaKategori;
  final String? namasubKategori;
  final String? namaPajak;
  final double? nominalpajak;
  final String? namaukuran;
  final String? jenisProduk;
  int qty = 0;
  final double? diskon;
  final int? stockawal;

  factory DataProdukTemp.fromJsondb(Map<String, dynamic> json) {
    return DataProdukTemp(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_kelompok_produk: json["id_kelompok_produk"],
      id_sub_kelompok_produk: json["id_sub_kelompok_produk"],
      gambar_produk_utama: json["gambar_produk_utama"],
      kode_produk: json["kode_produk"],
      nama_produk: json["nama_produk"],
      serial_key: json["serial_key"],
      imei: json["imei"],
      hitung_stok: json["hitung_stok"],
      tampilkan_di_produk: json["tampilkan_di_produk"],
      harga_beli: json["harga_beli"] ?? 0,
      hpp: json["hpp"] ?? 0,
      harga_jual_grosir: json["harga_jual_grosir"] ?? 0,
      harga_jual_eceran: json["harga_jual_eceran"] ?? 0,
      satuan_utama: json["satuan_utama"],
      isi_dalam_satuan: json["isi_dalam_satuan"] ?? 0,
      pajak: json["pajak"],
      info_stok_habis: json["info_stok_habis"] ?? 0,
      warna: json["warna"],
      ukuran: json["ukuran"],
      berat: json["berat"],
      volume_panjang: json["volume_panjang"],
      volume_lebar: json["volume_lebar"],
      volume_tinggi: json["volume_tinggi"],
      id_gambar: json["id_gambar"],
      id_harga_jual: json["id_harga_jual"],
      id_satuan: json["id_satuan"],
      namaPajak: json["nama_pajak"],
      namaukuran: json["nama_ukuran"],
      namaKategori: json["nama_kategori"],
      namasubKategori: json["nama_subkategori"],
      harga_jual_pelanggan: json["harga_jual_pelanggan"] ?? 0,
      jenisProduk: json["jenis_produk"],
      nominalpajak: json["nominal_pajak"],
      stockawal: json["stock_awal"],
      qty: json["qty"] ?? 0,
      diskon: json["diskon"] ?? 0.0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_kelompok_produk'] = id_kelompok_produk;
    map['id_sub_kelompok_produk'] = id_sub_kelompok_produk;
    map['gambar_produk_utama'] = gambar_produk_utama;
    map['kode_produk'] = kode_produk;
    map['nama_produk'] = nama_produk;
    map['serial_key'] = serial_key;
    map['imei'] = imei;
    map['hitung_stok'] = hitung_stok;
    map['tampilkan_di_produk'] = tampilkan_di_produk;
    map['harga_beli'] = harga_beli;
    map['hpp'] = hpp;
    map['harga_jual_grosir'] = harga_jual_grosir;
    map['harga_jual_eceran'] = harga_jual_eceran;
    map['satuan_utama'] = satuan_utama;
    map['isi_dalam_satuan'] = isi_dalam_satuan;
    map['pajak'] = pajak;
    map['info_stok_habis'] = info_stok_habis;
    map['warna'] = warna;
    map['ukuran'] = ukuran;
    map['berat'] = berat;
    map['volume_panjang'] = volume_panjang;
    map['volume_lebar'] = volume_lebar;
    map['volume_tinggi'] = volume_tinggi;
    map['id_gambar'] = id_gambar;
    map['id_harga_jual'] = id_harga_jual;
    map['id_satuan'] = id_satuan;
    map['harga_jual_pelanggan'] = harga_jual_pelanggan;
    map['jenis_produk'] = jenisProduk;
    map['stock_awal'] = stockawal;
    map['qty'] = qty;
    map['diskon'] = diskon;
    return map;
  }
}

class DataGambarProduk {
  DataGambarProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.gambar,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final dynamic gambar;
  final int? aktif;

  factory DataGambarProduk.fromJsondb(Map<String, dynamic> json) {
    return DataGambarProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      gambar: json["gambar"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['gambar'] = gambar;
    map['aktif'] = aktif;
    return map;
  }
}

class DataHargaJualProduk {
  DataHargaJualProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.jenis_transaksi,
    this.harga_jual,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final String? jenis_transaksi;
  final double? harga_jual;
  final int? aktif;

  factory DataHargaJualProduk.fromJsondb(Map<String, dynamic> json) {
    return DataHargaJualProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      jenis_transaksi: json["jenis_transaksi"],
      harga_jual: json["harga_jual"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['jenis_transaksi'] = jenis_transaksi;
    map['harga_jual'] = harga_jual;
    map['aktif'] = aktif;
    return map;
  }
}

class DataSatuanProduk {
  DataSatuanProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.nama_satuan,
    this.isi_per_satuan,
    this.harga_per_satuan,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final String? nama_satuan;
  final double? isi_per_satuan;
  final double? harga_per_satuan;
  final int? aktif;

  factory DataSatuanProduk.fromJsondb(Map<String, dynamic> json) {
    return DataSatuanProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      nama_satuan: json["nama_satuan"],
      isi_per_satuan: json["isi_per_satuan"],
      harga_per_satuan: json["harga_per_satuan"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['nama_satuan'] = nama_satuan;
    map['isi_per_satuan'] = isi_per_satuan;
    map['harga_per_satuan'] = harga_per_satuan;
    map['aktif'] = aktif;
    return map;
  }
}

class DataPajakProduk {
  DataPajakProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.nama_pajak,
    this.nominal_pajak,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final String? nama_pajak;
  final double? nominal_pajak;
  final dynamic aktif;

  factory DataPajakProduk.fromJsondb(Map<String, dynamic> json) {
    return DataPajakProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      nama_pajak: json["nama_pajak"],
      nominal_pajak: json["nominal_pajak"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['nama_pajak'] = nama_pajak;
    map['nominal_pajak'] = nominal_pajak;
    map['aktif'] = aktif;
    return map;
  }
}

class DataUkuranProduk {
  DataUkuranProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.ukuran,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final String? ukuran;
  final int? aktif;

  factory DataUkuranProduk.fromJsondb(Map<String, dynamic> json) {
    return DataUkuranProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      ukuran: json["ukuran"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['ukuran'] = ukuran;
    map['aktif'] = aktif;
    return map;
  }
}

class DataPaketProduk {
  DataPaketProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.nama_paket,
    this.gambar_utama,
    this.harga_modal,
    this.hpp,
    this.harga_jual_paket,
    this.pajak,
    this.tampilkan_di_paket,
    this.sync,
    this.aktif,
    this.namapajak,
    this.nominalpajak,
    this.hitungStock,
    this.diskon,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? nama_paket;
  dynamic gambar_utama; // Assuming this can be a BLOB or any other type
  final double? harga_modal;
  final double? hpp;
  final double? harga_jual_paket;
  final String? pajak;
  final int? tampilkan_di_paket;
  final String? sync;
  final int? aktif;
  final double? nominalpajak;
  final String? namapajak;
  final int? hitungStock;
  final double? diskon;

  factory DataPaketProduk.fromJsondb(Map<String, dynamic> json) {
    return DataPaketProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      nama_paket: json["nama_paket"],
      gambar_utama: json["gambar_utama"],
      harga_modal: json["harga_modal"] ?? 0,
      hpp: json["hpp"] ?? 0,
      harga_jual_paket: json["harga_jual_paket"] ?? 0,
      pajak: json["pajak"],
      tampilkan_di_paket: json["tampilkan_di_paket"],
      sync: json["sync"],
      aktif: json["aktif"],
      nominalpajak: json["nominal_pajak"] ?? 0.0,
      namapajak: json["nama_pajak"],
      hitungStock: json["hitung_stock"],
      diskon: json["diskon"] ?? 0.0,
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['nama_paket'] = nama_paket;
    map['gambar_utama'] = gambar_utama;
    map['harga_modal'] = harga_modal;
    map['hpp'] = hpp;
    map['harga_jual_paket'] = harga_jual_paket;
    map['pajak'] = pajak;
    map['tampilkan_di_paket'] = tampilkan_di_paket;
    map['sync'] = sync;
    map['aktif'] = aktif;
    map['hitung_stock'] = hitungStock;
    map['diskon'] = diskon;
    return map;
  }
}

class DataDetailPaketProduk {
  DataDetailPaketProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_paket_produk,
    this.id_produk,
    this.harga_modal,
    this.hpp,
    required this.qty,
    this.sub_harga_modal,
    this.sub_hpp,
    this.sync,
    this.aktif,
    this.namaproduk,
    this.hargabeliproduk,
    this.gambarproduk,
    this.hargaeceranproduk,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_paket_produk;
  final String? id_produk;
  final double? harga_modal;
  final double? hpp;
  int qty = 0;
  final double? sub_harga_modal;
  final double? sub_hpp;
  final String? sync;
  final int? aktif;
  final String? namaproduk;
  final double? hargabeliproduk;
  final String? gambarproduk;
  double? hargaeceranproduk;

  factory DataDetailPaketProduk.fromJsondb(Map<String, dynamic> json) {
    return DataDetailPaketProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_paket_produk: json["id_paket_produk"],
      id_produk: json["id_produk"],
      harga_modal: json["harga_modal"] ?? 0,
      hpp: json["hpp"] ?? 0,
      qty: json["qty"] ?? 0,
      sub_harga_modal: json["sub_harga_modal"] ?? 0,
      sub_hpp: json["sub_hpp"] ?? 0,
      sync: json["sync"],
      aktif: json["aktif"],
      namaproduk: json["nama_produk"],
      hargabeliproduk: json["harga_beli_produk"],
      gambarproduk: json["gambar_produk"],
      hargaeceranproduk: json["harga_eceran_produk"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_paket_produk'] = id_paket_produk;
    map['id_produk'] = id_produk;
    map['harga_modal'] = harga_modal;
    map['hpp'] = hpp;
    map['qty'] = qty;
    map['sub_harga_modal'] = sub_harga_modal;
    map['sub_hpp'] = sub_hpp;
    map['sync'] = sync;
    map['aktif'] = aktif;
    return map;
  }
}

class DataStockProduk {
  DataStockProduk({
    this.id,
    this.uuid,
    this.id_toko,
    this.id_produk,
    this.hpp,
    this.stok,
    this.sync,
    this.aktif,
  });

  final int? id;
  final String? uuid;
  final String? id_toko;
  final String? id_produk;
  final double? hpp;
  final int? stok;
  final String? sync;
  final int? aktif;

  factory DataStockProduk.fromJsondb(Map<String, dynamic> json) {
    return DataStockProduk(
      id: json["id"],
      uuid: json['uuid'],
      id_toko: json["id_toko"],
      id_produk: json["id_produk"],
      hpp: json["hpp"] ?? 0,
      stok: json["stok"] ?? 0,
      sync: json["sync"],
      aktif: json["aktif"],
    );
  }

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['id_toko'] = id_toko;
    map['id_produk'] = id_produk;
    map['hpp'] = hpp;
    map['stok'] = stok;
    map['sync'] = sync;
    map['aktif'] = aktif;
    return map;
  }
}
