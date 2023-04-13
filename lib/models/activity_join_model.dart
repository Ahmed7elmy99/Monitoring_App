class ActivityJoinModel {
  final String id;
  final String childId;
  final String schoolActivityId;
  final String activityStatus;

  ActivityJoinModel({
    required this.id,
    required this.childId,
    required this.schoolActivityId,
    required this.activityStatus,
  });

  factory ActivityJoinModel.fromJson(Map<String, dynamic> json) {
    return ActivityJoinModel(
      id: json['id'],
      childId: json['childId'],
      schoolActivityId: json['schoolActivityId'],
      activityStatus: json['activityStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'schoolActivityId': schoolActivityId,
      'activityStatus': activityStatus,
    };
  }
}
