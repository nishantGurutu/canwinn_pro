class LogActivityModel {
  int? id;
  int? userId;
  String? activityType;
  String? description;
  String? ipAddress;
  String? createdAt;
  String? updatedAt;

  LogActivityModel(
      {this.id,
      this.userId,
      this.activityType,
      this.description,
      this.ipAddress,
      this.createdAt,
      this.updatedAt});

  LogActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    activityType = json['activity_type'];
    description = json['description'];
    ipAddress = json['ip_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['activity_type'] = this.activityType;
    data['description'] = this.description;
    data['ip_address'] = this.ipAddress;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
