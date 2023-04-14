class TeacherModel {
  final String id;
  final String schoolId;
  final String name;
  final String email;
  final String password;
  final String university;
  final String subject;
  final String image;
  final String phone;
  final String gender;
  final String age;
  final String address;
  final String ban;
  final String createdAt;

  TeacherModel({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.email,
    required this.password,
    required this.university,
    required this.subject,
    required this.image,
    required this.phone,
    required this.gender,
    required this.age,
    required this.address,
    required this.ban,
    required this.createdAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'],
      schoolId: json['schoolId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      university: json['university'] == null ? '' : json['university'],
      subject: json['subject'] == null ? '' : json['subject'],
      image: json['image'],
      phone: json['phone'],
      gender: json['gender'] == null ? '' : json['gender'],
      age: json['age'] == null ? '' : json['age'],
      address: json['address'],
      ban: json['ban'],
      createdAt: json['createdAt'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'email': email,
      'password': password,
      'university': university,
      'subject': subject,
      'image': image,
      'phone': phone,
      'gender': gender,
      'age': age,
      'address': address,
      'ban': ban,
      'createdAt': createdAt,
    };
  }
}
