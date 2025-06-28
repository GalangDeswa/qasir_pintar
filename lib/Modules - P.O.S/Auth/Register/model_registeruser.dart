class RegisterUserModel {
  RegisterUserModel({
    required this.status,
    required this.message,
    required this.user,
  });

  final bool? status;
  final String? message;
  final User? user;

  RegisterUserModel copyWith({
    bool? status,
    String? message,
    User? user,
  }) {
    return RegisterUserModel(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      status: json["status"],
      message: json["message"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return "$status, $message, $user, ";
  }
}

class User {
  User({
    required this.name,
    required this.phone,
    required this.referralCode,
    required this.email,
    required this.id,
    required this.logoUrl,
    required this.registerDate,
    required this.statusUser,
  });

  final String? name;
  final String? phone;
  final dynamic referralCode;
  final String? email;
  final int? id;
  final String? logoUrl;
  final DateTime? registerDate;
  final String? statusUser;

  User copyWith({
    String? name,
    String? phone,
    dynamic? referralCode,
    String? email,
    int? id,
    String? logoUrl,
    DateTime? registerDate,
    String? statusUser,
  }) {
    return User(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      referralCode: referralCode ?? this.referralCode,
      email: email ?? this.email,
      id: id ?? this.id,
      logoUrl: logoUrl ?? this.logoUrl,
      registerDate: registerDate ?? this.registerDate,
      statusUser: statusUser ?? this.statusUser,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      phone: json["phone"],
      referralCode: json["referral_code"],
      email: json["email"],
      id: json["id"],
      logoUrl: json["logo_url"],
      registerDate: DateTime.tryParse(json["register_date"] ?? ""),
      statusUser: json["status_user"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "referral_code": referralCode,
        "email": email,
        "id": id,
        "logo_url": logoUrl,
        "register_date": registerDate?.toIso8601String(),
        "status_user": statusUser,
      };

  @override
  String toString() {
    return "$name, $phone, $referralCode, $email, $id, $logoUrl, $registerDate, $statusUser, ";
  }
}
