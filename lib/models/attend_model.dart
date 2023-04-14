class AttendModel {
  final String id;
  final String childId;
  final String classId;
  final String teacherId;
  final String date;
  final String status;

  AttendModel({
    required this.id,
    required this.childId,
    required this.classId,
    required this.teacherId,
    required this.date,
    required this.status,
  });

  factory AttendModel.fromJson(Map<String, dynamic> json) {
    return AttendModel(
      id: json['id'],
      childId: json['childId'],
      classId: json['classId'],
      teacherId: json['teacherId'],
      date: json['date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'classId': classId,
      'teacherId': teacherId,
      'date': date,
      'status': status,
    };
  }
}
