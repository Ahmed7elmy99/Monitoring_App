class SchoolModel {
  final String id;
  final String name;
  final String description;
  final String phone;
  final String image;
  final String location;
  final String establishedIn;
  final String establishedBy;
  final String website;
  final String ban;
  final String createdAt;

  SchoolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.image,
    required this.location,
    required this.establishedIn,
    required this.establishedBy,
    required this.website,
    required this.ban,
    required this.createdAt,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phone: json['phone'],
      image: json['image'],
      location: json['location'],
      establishedIn: json['establishedIn'],
      establishedBy: json['establishedBy'],
      website: json['website'],
      ban: json['ban'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phone': phone,
      'image': image,
      'location': location,
      'establishedIn': establishedIn,
      'establishedBy': establishedBy,
      'website': website,
      'ban': ban,
      'createdAt': createdAt,
    };
  }
}
