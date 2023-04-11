class SchoolRequestModel {
  final String id;
  final String childId;
  final String schoolId;
  final String requestStatus;
  final String note;
  final String createdAt;

  SchoolRequestModel({
    required this.id,
    required this.childId,
    required this.schoolId,
    required this.requestStatus,
    required this.note,
    required this.createdAt,
  });

  factory SchoolRequestModel.fromJson(Map<String, dynamic> json) {
    return SchoolRequestModel(
      id: json['id'],
      childId: json['childId'],
      schoolId: json['schoolId'],
      requestStatus: json['requestStatus'],
      note: json['note'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'schoolId': schoolId,
      'requestStatus': requestStatus,
      'note': note,
      'createdAt': createdAt,
    };
  }
}
