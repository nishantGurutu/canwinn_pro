class ResponsiblePersonListModel {
  bool? status;
  String? message;
  List<ResponsiblePersonData>? data;

  ResponsiblePersonListModel({this.status, this.message, this.data});

  ResponsiblePersonListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ResponsiblePersonData>[];
      json['data'].forEach((v) {
        data!.add(new ResponsiblePersonData.fromJson(v));
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

class ResponsiblePersonData {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic departmentId;
  dynamic role;
  dynamic phone;
  dynamic phone2;
  dynamic image;
  dynamic gender;
  dynamic dob;
  dynamic emailVerifiedAt;
  dynamic recoveryPassword;
  dynamic location;
  dynamic fcmToken;
  dynamic status;
  dynamic type;
  dynamic isLoggedIn;
  dynamic deviceId;
  dynamic createdAt;
  dynamic updatedAt;

  ResponsiblePersonData(
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

  ResponsiblePersonData.fromJson(Map<String, dynamic> json) {
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
