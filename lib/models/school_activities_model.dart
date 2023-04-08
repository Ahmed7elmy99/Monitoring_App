class schoolActivities {
  final String id;
  final String schoolId;
  final String name;
  final String description;
  final String price;
  final String discount;
  final String date;
  final String activityType;
  final String createdAt;

  schoolActivities({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.date,
    required this.activityType,
    required this.createdAt,
  });

  factory schoolActivities.fromJson(Map<String, dynamic> json) {
    return schoolActivities(
      id: json['id'],
      schoolId: json['schoolId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      discount: json['discount'],
      date: json['date'],
      activityType: json['activityType'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'date': date,
      'activityType': activityType,
      'createdAt': createdAt,
    };
  }
}
