class LoginModel {
  bool? status;
  dynamic message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic shiftId;
  dynamic departmentId;
  dynamic checkinType;
  dynamic attendanceType;
  dynamic roleId;
  dynamic phone;
  dynamic gender;
  dynamic dob;
  dynamic image;
  dynamic recoveryPassword;
  dynamic fcmToken;
  dynamic type;
  dynamic token;
  dynamic assignedDept;
  dynamic isHead;
  dynamic roleName;
  dynamic tokenType;

  Data(
      {this.id,
      this.name,
      this.email,
      this.departmentId,
      this.shiftId,
      this.checkinType,
      this.attendanceType,
      this.roleId,
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
      this.roleName,
      this.tokenType});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    departmentId = json['department_id'];
    shiftId = json['shift_id'];
    checkinType = json['checkin_type'];
    attendanceType = json['attendance_type'];
    roleId = json['role_id'];
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
    roleName = json['role_name'];
    tokenType = json['token_type'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department_id'] = this.departmentId;
    data['shift_id'] = this.shiftId;
    data['checkin_type'] = this.checkinType;
    data['attendance_type'] = this.attendanceType;
    data['role_id'] = this.roleId;
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
    data['role_name'] = this.roleName;
    data['token_type'] = this.tokenType;
    return data;
  }
}
