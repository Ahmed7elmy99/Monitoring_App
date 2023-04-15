class ReportModel {
  final String id;
  final String childId;
  final String teacherId;
  final String file;

  ReportModel({
    required this.id,
    required this.childId,
    required this.teacherId,
    required this.file,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      childId: json['childId'],
      teacherId: json['teacherId'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'teacherId': teacherId,
      'file': file,
    };
  }
}
