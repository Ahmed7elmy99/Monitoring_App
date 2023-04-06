class AdminModels {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String phone;
  String? image;
  final String gender;
  final String? createdAt;
  final String? ban;

  AdminModels({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.phone,
    this.image,
    required this.gender,
    this.createdAt,
    this.ban,
  });

  factory AdminModels.fromJson(Map<String, dynamic> json) {
    return AdminModels(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      image: json['image'],
      gender: json['gender'],
      createdAt: json['createdAt'],
      ban: json['ban'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'image': image,
      'gender': gender,
      'createdAt': createdAt,
      'ban': ban,
    };
  }
}
