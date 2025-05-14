class ModelDistrict {
  ModelDistrict({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<DataDistrict> data;

  ModelDistrict copyWith({
    bool? status,
    String? message,
    List<DataDistrict>? data,
  }) {
    return ModelDistrict(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ModelDistrict.fromJson(Map<String, dynamic> json) {
    return ModelDistrict(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<DataDistrict>.from(json["data"]!.map((x) => DataDistrict.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
      };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }
}

class DataDistrict {
  DataDistrict({
    required this.id,
    required this.provinceId,
    required this.regencyId,
    required this.name,
  });

  final int? id;
  final int? provinceId;
  final int? regencyId;
  final String? name;

  DataDistrict copyWith({
    int? id,
    int? provinceId,
    int? regencyId,
    String? name,
  }) {
    return DataDistrict(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      regencyId: regencyId ?? this.regencyId,
      name: name ?? this.name,
    );
  }

  factory DataDistrict.fromJson(Map<String, dynamic> json) {
    return DataDistrict(
      id: json["id"],
      provinceId: json["province_id"],
      regencyId: json["regency_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "regency_id": regencyId,
        "name": name,
      };

  @override
  String toString() {
    return "$id, $provinceId, $regencyId, $name, ";
  }
}
