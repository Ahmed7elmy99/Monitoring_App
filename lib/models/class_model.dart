class ClassModel {
  final String id;
  final String schoolId;
  final String name;
  final String educationalLevel;
  final String createdAt;

  ClassModel({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.educationalLevel,
    required this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      schoolId: json['schoolId'],
      name: json['name'],
      educationalLevel: json['educationalLevel'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'educationalLevel': educationalLevel,
      'createdAt': createdAt,
    };
  }
}
