class FeedEventListModel {
  bool? status;
  String? message;
  List<FeedEventListData>? data;

  FeedEventListModel({this.status, this.message, this.data});

  FeedEventListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FeedEventListData>[];
      json['data'].forEach((v) {
        data!.add(new FeedEventListData.fromJson(v));
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

class FeedEventListData {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? eventDate;
  String? eventTime;
  String? eventVenue;
  int? eventType;
  String? attendUsers;
  String? reminder;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<AttendUserDetails>? attendUserDetails;

  FeedEventListData(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.eventDate,
      this.eventTime,
      this.eventVenue,
      this.eventType,
      this.attendUsers,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.attendUserDetails});

  FeedEventListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
    eventVenue = json['event_venue'];
    eventType = json['event_type'];
    attendUsers = json['attend_users'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['attend_user_details'] != null) {
      attendUserDetails = <AttendUserDetails>[];
      json['attend_user_details'].forEach((v) {
        attendUserDetails!.add(new AttendUserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['event_date'] = this.eventDate;
    data['event_time'] = this.eventTime;
    data['event_venue'] = this.eventVenue;
    data['event_type'] = this.eventType;
    data['attend_users'] = this.attendUsers;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attendUserDetails != null) {
      data['attend_user_details'] =
          this.attendUserDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendUserDetails {
  int? id;
  String? name;
  String? email;
  int? departmentId;
  int? role;
  String? phone;
  String? phone2;
  dynamic image;
  String? gender;
  String? dob;
  dynamic emailVerifiedAt;
  String? recoveryPassword;
  dynamic location;
  String? fcmToken;
  int? status;
  int? type;
  int? isLoggedIn;
  String? deviceId;
  String? createdAt;
  String? updatedAt;

  AttendUserDetails(
      {this.id,
      this.name,
      this.email,
      this.departmentId,
      this.role,
      this.phone,
      this.phone2,
      this.image,
      this.gender,
      this.dob,
      this.emailVerifiedAt,
      this.recoveryPassword,
      this.location,
      this.fcmToken,
      this.status,
      this.type,
      this.isLoggedIn,
      this.deviceId,
      this.createdAt,
      this.updatedAt});

  AttendUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    departmentId = json['department_id'];
    role = json['role'];
    phone = json['phone'];
    phone2 = json['phone2'];
    image = json['image'];
    gender = json['gender'];
    dob = json['dob'];
    emailVerifiedAt = json['email_verified_at'];
    recoveryPassword = json['recovery_password'];
    location = json['location'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    type = json['type'];
    isLoggedIn = json['is_logged_in'];
    deviceId = json['device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department_id'] = this.departmentId;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['phone2'] = this.phone2;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['recovery_password'] = this.recoveryPassword;
    data['location'] = this.location;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['type'] = this.type;
    data['is_logged_in'] = this.isLoggedIn;
    data['device_id'] = this.deviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
