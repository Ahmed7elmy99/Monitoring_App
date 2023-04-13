class ChildrenModel {
  final String id;
  final String parentId;
  final String schoolId;
  final String classId;
  final String activityId;
  final String name;
  final String gender;
  final int age;
  final String educationLevel;
  final String certificate;
  final String phone;
  final String image;

  final String createdAt;

  ChildrenModel({
    required this.id,
    required this.parentId,
    required this.schoolId,
    required this.classId,
    required this.activityId,
    required this.name,
    required this.gender,
    required this.age,
    required this.educationLevel,
    required this.certificate,
    required this.phone,
    required this.image,
    required this.createdAt,
  });

  factory ChildrenModel.fromJson(Map<String, dynamic> json) {
    return ChildrenModel(
      id: json['id'],
      parentId: json['parentId'],
      schoolId: json['schoolId'],
      classId: json['classId'],
      activityId: json['activityId'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      educationLevel: json['educationLevel'],
      certificate: json['certificate'],
      phone: json['phone'],
      image: json['image'],
      createdAt: json['createdAt'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'schoolId': schoolId,
      'classId': classId,
      'activityId': activityId,
      'name': name,
      'gender': gender,
      'age': age,
      'educationLevel': educationLevel,
      'certificate': certificate,
      'phone': phone,
      'image': image,
      'createdAt': createdAt,
    };
  }
}
