class LoginModel {
  bool? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? name;
  String? email;
  int? departmentId;
  int? shiftId;
  int? checkinType;
  int? attendanceType;
  int? role;
  String? phone;
  String? gender;
  String? dob;
  String? image;
  String? recoveryPassword;
  String? fcmToken;
  int? type;
  String? token;
  String? assignedDept;
  int? isHead;
  String? tokenType;

  Data(
      {this.id,
      this.name,
      this.email,
      this.departmentId,
      this.shiftId,
      this.checkinType,
      this.attendanceType,
      this.role,
      this.phone,
      this.gender,
      this.dob,
      this.image,
      this.recoveryPassword,
      this.fcmToken,
      this.type,
      this.token,
      this.assignedDept,
      this.isHead,
      this.tokenType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    departmentId = json['department_id'];
    shiftId = json['shift_id'];
    checkinType = json['checkin_type'];
    attendanceType = json['attendance_type'];
    role = json['role'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
    image = json['image'];
    recoveryPassword = json['recovery_password'];
    fcmToken = json['fcm_token'];
    type = json['type'];
    token = json['token'];
    assignedDept = json['assigned_dept'];
    isHead = json['is_head'];
    tokenType = json['token_type'];
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
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['recovery_password'] = this.recoveryPassword;
    data['fcm_token'] = this.fcmToken;
    data['type'] = this.type;
    data['token'] = this.token;
    data['assigned_dept'] = this.assignedDept;
    data['is_head'] = this.isHead;
    data['token_type'] = this.tokenType;
    return data;
  }
}
