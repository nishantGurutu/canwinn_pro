class VisitType {
  final int id;
  final String name;
  final int status;
  final String createdAt;
  final String updatedAt;

  VisitType({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitType.fromJson(Map<String, dynamic> json) {
    return VisitType(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
