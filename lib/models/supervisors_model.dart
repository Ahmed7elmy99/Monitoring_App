class SupervisorsModel {
  final String id;
  final String schoolsId;
  final String name;
  final String email;
  final String password;
  final String gender;
  final String age;
  final String phone;
  final String image;
  final String ban;
  final String createdAt;

  SupervisorsModel({
    required this.id,
    required this.schoolsId,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.age,
    required this.phone,
    required this.image,
    required this.ban,
    required this.createdAt,
  });

  factory SupervisorsModel.fromJson(Map<String, dynamic> json) {
    return SupervisorsModel(
      id: json['id'],
      schoolsId: json['schoolsId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      age: json['age'],
      phone: json['phone'],
      image: json['image'],
      ban: json['ban'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolsId': schoolsId,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'age': age,
      'phone': phone,
      'image': image,
      'ban': ban,
      'createdAt': createdAt,
    };
  }
}
