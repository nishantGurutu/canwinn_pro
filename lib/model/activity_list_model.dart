class ActivityListModel {
  bool? status;
  String? message;
  List<ActivityData>? data;

  ActivityListModel({this.status, this.message, this.data});

  ActivityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivityData>[];
      json['data'].forEach((v) {
        data!.add(new ActivityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityData {
  int? id;
  int? userId;
  String? title;
  int? activityType;
  String? dueDate;
  String? time;
  String? guest;
  String? description;
  int? company;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? companyName;
  String? guestName;

  ActivityData(
      {this.id,
      this.userId,
      this.title,
      this.activityType,
      this.dueDate,
      this.time,
      this.guest,
      this.description,
      this.company,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.companyName,
      this.guestName});

  ActivityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    activityType = json['activity_type'];
    dueDate = json['due_date'];
    time = json['time'];
    guest = json['guest'];
    description = json['description'];
    company = json['company'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyName = json['company_name'];
    guestName = json['guest_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['activity_type'] = this.activityType;
    data['due_date'] = this.dueDate;
    data['time'] = this.time;
    data['guest'] = this.guest;
    data['description'] = this.description;
    data['company'] = this.company;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['company_name'] = this.companyName;
    data['guest_name'] = this.guestName;
    return data;
  }
}
