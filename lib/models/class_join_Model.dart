class ClassJoinModel {
  final String id;
  final String childId;
  final String classId;

  ClassJoinModel({
    required this.id,
    required this.childId,
    required this.classId,
  });

  factory ClassJoinModel.fromJson(Map<String, dynamic> json) {
    return ClassJoinModel(
      id: json['id'],
      childId: json['childId'],
      classId: json['classId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'classId': classId,
    };
  }
}
