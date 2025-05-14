class User {
  User({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final DataUser? data;

  User copyWith({
    bool? status,
    String? message,
    DataUser? data,
  }) {
    return User(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataUser.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }
}

class DataUser {
  DataUser(
      {this.id,
      this.uuid,
      this.name,
      this.phone,
      this.email,
      this.referralCode,
      this.referralCodeget,
      this.businessName,
      this.pin,
      this.logo,
      this.businessTypeId,
      this.provinceId,
      this.districtId,
      this.regencyId,
      this.address,
      this.packageId,
      this.startDate,
      this.endDate,
      this.status,
      this.logoUrl,
      this.registerDate,
      this.statusUser,
      this.provinceName,
      this.regencyName,
      this.districtName,
      this.businessTypeName,
      this.password});

  final int? id;
  final String? uuid;
  final String? name;
  final String? phone;
  final String? email;
  final dynamic referralCode;
  final dynamic referralCodeget;
  final dynamic businessName;
  final dynamic pin;
  final String? logo;
  final dynamic businessTypeId;
  final dynamic provinceId;
  final dynamic districtId;
  final dynamic regencyId;
  final dynamic address;
  final int? packageId;
  final String? startDate;
  final String? endDate;
  final int? status;
  final String? logoUrl;
  final String? registerDate;
  final statusUser;
  // New fields for joined data
  final String? provinceName;
  final String? regencyName;
  final String? districtName;
  final String? password;
  final String? businessTypeName;

  DataUser copyWith({
    int? id,
    String? uuid,
    String? name,
    String? phone,
    String? email,
    dynamic? referralCode,
    dynamic? referralCodget,
    dynamic? businessName,
    dynamic? pin,
    String? logo,
    dynamic? businessTypeId,
    dynamic? provinceId,
    dynamic? districtId,
    dynamic? regencyId,
    dynamic? address,
    int? packageId,
    // DateTime? startDate,
    // DateTime? endDate,
    String? startDate,
    String? sendDate,
    int? status,
    String? logoUrl,
    //DateTime? registerDate,
    String? registerDate,
    String? statusUser,
    // String? province,
    // String? regency,
    // String? district
  }) {
    return DataUser(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      referralCode: referralCode ?? this.referralCode,
      businessName: businessName ?? this.businessName,
      pin: pin ?? this.pin,
      logo: logo ?? this.logo,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      provinceId: provinceId ?? this.provinceId,
      districtId: districtId ?? this.districtId,
      regencyId: regencyId ?? this.regencyId,
      address: address ?? this.address,
      packageId: packageId ?? this.packageId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      logoUrl: logoUrl ?? this.logoUrl,
      registerDate: registerDate ?? this.registerDate,
      statusUser: statusUser ?? this.statusUser,
    );
  }

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      id: json["id"],
      uuid: json['uuid'] != null ? json['uuid'] : '',
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      referralCode: json["referral_code"],
      businessName: json["business_name"],
      pin: json["pin"],
      logo: json["logo"],
      businessTypeId: json["business_type_id"],
      provinceId: json["province_id"],
      districtId: json["district_id"],
      regencyId: json["regency_id"],
      address: json["address"],
      packageId: json["package_id"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      status: json["status"],
      logoUrl: json["logo_url"],
      registerDate: json["register_date"],
      statusUser: json["status_user"],
    );
  }
  String? province;
  String? regency;
  String? district;
  factory DataUser.fromJsondb(Map<String, dynamic> json) {
    return DataUser(
      id: json["id"],
      uuid: json['uuid'],
      name: json["nama"],
      phone: json["telp"],
      email: json["email"],
      referralCode: json["referral_code"],
      businessName: json["nama_usaha"],
      pin: json["pin"],
      logo: json["logo"] ?? '-',
      businessTypeId: json["business_type_id"],
      provinceId: json["pilih_provinsi"],
      districtId: json["pilih_kecamatan"],
      regencyId: json["pilih_kabupaten"],
      address: json["alamat"],
      packageId: json["package_id"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      status: json["status"],
      logoUrl: json["logo_url"],
      registerDate: json["register_date"],
      statusUser: json["aktif"],
      provinceName: json['province_name'],
      regencyName: json['regency_name'],
      districtName: json['district_name'],
      businessTypeName: json['business_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        'uuid': uuid,
        "name": name,
        "phone": phone,
        "email": email,
        "referral_code": referralCode,
        "business_name": businessName,
        "pin": pin,
        "logo": logo,
        "business_type_id": businessTypeId,
        "province_id": provinceId,
        "district_id": districtId,
        "regency_id": regencyId,
        "address": address,
        "package_id": packageId,
        // "start_date": startDate?.toIso8601String(),
        // "end_date": endDate?.toIso8601String(),
        "start_date": startDate,
        "end_date": endDate,
        "status": status,
        "logo_url": logoUrl,
        "register_date": registerDate,
        "status_user": statusUser,
      };

  Map<String, dynamic> DB() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['email'] = email;
    map['psw'] = password;
    map['telp'] = phone;
    map['nama'] = name;
    map['kode_referal_opsi'] = referralCode;
    map['tanggal_daftar'] = registerDate;
    map['nama_usaha'] = businessName;
    map['logo'] = logo;
    map['id_jenis_usaha'] = businessTypeId;
    map['pilih_provinsi'] = provinceId;
    map['pilih_kabupaten'] = regencyId;
    map['pilih_kecamatan'] = districtId;
    map['alamat'] = address;
    map['kode_referal'] = referralCodeget;
    map['aktif'] = statusUser;
    return map;
  }

  @override
  String toString() {
    return "$id, $name, $phone, $email, $referralCode, $businessName, $pin, $logo, $businessTypeId, $provinceId, $districtId, $regencyId, $address, $packageId, $startDate, $endDate, $status, $logoUrl, $registerDate, $statusUser, ";
  }
}
