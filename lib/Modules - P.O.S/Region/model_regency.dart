class ModelRegency {
  ModelRegency({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<DataRegency> data;

  ModelRegency copyWith({
    bool? status,
    String? message,
    List<DataRegency>? data,
  }) {
    return ModelRegency(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ModelRegency.fromJson(Map<String, dynamic> json) {
    return ModelRegency(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<DataRegency>.from(
              json["data"]!.map((x) => DataRegency.fromJson(x))),
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

class DataRegency {
  DataRegency({
    required this.id,
    required this.provinceId,
    required this.name,
  });

  final int? id;
  final int? provinceId;
  final String? name;

  DataRegency copyWith({
    int? id,
    int? provinceId,
    String? name,
  }) {
    return DataRegency(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      name: name ?? this.name,
    );
  }

  factory DataRegency.fromJson(Map<String, dynamic> json) {
    return DataRegency(
      id: json["id"],
      provinceId: json["province_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
      };

  @override
  String toString() {
    return "$id, $provinceId, $name, ";
  }
}
