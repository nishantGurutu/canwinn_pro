class AttendenceUserDetails {
  bool? status;
  String? message;
  AttendenceUserData? data;

  AttendenceUserDetails({this.status, this.message, this.data});

  AttendenceUserDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new AttendenceUserData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AttendenceUserData {
  int? id;
  String? name;
  String? email;
  int? departmentId;
  int? shiftId;
  int? checkinType;
  int? attendanceType;
  int? role;
  String? phone;
  String? phone2;
  String? image;
  String? gender;
  String? dob;
  dynamic emailVerifiedAt;
  String? recoveryPassword;
  dynamic location;
  String? fcmToken;
  int? status;
  int? type;
  String? anniversaryDate;
  String? anniversaryType;
  String? brandingImage;
  int? isLoggedIn;
  dynamic deviceId;
  String? createdAt;
  String? updatedAt;
  int? punchin;

  AttendenceUserData(
      {this.id,
      this.name,
      this.email,
      this.departmentId,
      this.shiftId,
      this.checkinType,
      this.attendanceType,
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
      this.anniversaryDate,
      this.anniversaryType,
      this.brandingImage,
      this.isLoggedIn,
      this.deviceId,
      this.createdAt,
      this.updatedAt,
      this.punchin});

  AttendenceUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    departmentId = json['department_id'];
    shiftId = json['shift_id'];
    checkinType = json['checkin_type'];
    attendanceType = json['attendance_type'];
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
    anniversaryDate = json['anniversary_date'];
    anniversaryType = json['anniversary_type'];
    brandingImage = json['branding_image'];
    isLoggedIn = json['is_logged_in'];
    deviceId = json['device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    punchin = json['punchin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department_id'] = this.departmentId;
    data['shift_id'] = this.shiftId;
    data['checkin_type'] = this.checkinType;
    data['attendance_type'] = this.attendanceType;
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
    data['anniversary_date'] = this.anniversaryDate;
    data['anniversary_type'] = this.anniversaryType;
    data['branding_image'] = this.brandingImage;
    data['is_logged_in'] = this.isLoggedIn;
    data['device_id'] = this.deviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['punchin'] = this.punchin;
    return data;
  }
}
