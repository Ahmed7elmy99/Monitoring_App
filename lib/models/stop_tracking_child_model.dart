class StopTrackingChildModel {
  final String id;
  final String childId;
  final String supervisorId;
  final String note;

  StopTrackingChildModel({
    required this.id,
    required this.childId,
    required this.supervisorId,
    required this.note,
  });

  StopTrackingChildModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        childId = json['childId'],
        supervisorId = json['supervisorId'],
        note = json['note'] == null ? '' : json['note'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'supervisorId': supervisorId,
      'note': note,
    };
  }
}
