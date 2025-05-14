class ModelProvince {
  ModelProvince({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<DataProvince> data;

  ModelProvince copyWith({
    bool? status,
    String? message,
    List<DataProvince>? data,
  }) {
    return ModelProvince(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ModelProvince.fromJson(Map<String, dynamic> json) {
    return ModelProvince(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<DataProvince>.from(
              json["data"]!.map((x) => DataProvince.fromJson(x))),
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

class DataProvince {
  DataProvince({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  DataProvince copyWith({
    int? id,
    String? name,
  }) {
    return DataProvince(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory DataProvince.fromJson(Map<String, dynamic> json) {
    return DataProvince(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return "$id, $name, ";
  }
}
