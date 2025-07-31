class InScreenChalanDetailsModel {
  bool? status;
  String? message;
  Data? data;

  InScreenChalanDetailsModel({this.status, this.message, this.data});

  InScreenChalanDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? challanNumber;
  String? date;
  String? name;
  String? address;
  String? entryToDepartment;
  String? uploadImage;
  String? purpose;
  String? contact;
  String? hrId;
  int? deptUserId;
  String? deptApproveRejectTime;
  int? status;
  String? remarks;
  String? deptRemarks;
  String? createdAt;
  String? updatedAt;
  String? departmentUsername;
  String? securityName;
  String? approveTime;
  String? challanCreateTime;

  Data(
      {this.id,
        this.userId,
        this.challanNumber,
        this.date,
        this.name,
        this.address,
        this.entryToDepartment,
        this.uploadImage,
        this.purpose,
        this.contact,
        this.hrId,
        this.deptUserId,
        this.deptApproveRejectTime,
        this.status,
        this.remarks,
        this.deptRemarks,
        this.createdAt,
        this.updatedAt,
        this.departmentUsername,
        this.securityName,
        this.approveTime,
        this.challanCreateTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    challanNumber = json['challan_number'];
    date = json['date'];
    name = json['name'];
    address = json['address'];
    entryToDepartment = json['entry_to_department'];
    uploadImage = json['upload_image'];
    purpose = json['purpose'];
    contact = json['contact'];
    hrId = json['hr_id'];
    deptUserId = json['dept_user_id'];
    deptApproveRejectTime = json['dept_approve_reject_time'];
    status = json['status'];
    remarks = json['remarks'];
    deptRemarks = json['dept_remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    departmentUsername = json['department_username'];
    securityName = json['security_name'];
    approveTime = json['approve_time'];
    challanCreateTime = json['challan_create_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['challan_number'] = this.challanNumber;
    data['date'] = this.date;
    data['name'] = this.name;
    data['address'] = this.address;
    data['entry_to_department'] = this.entryToDepartment;
    data['upload_image'] = this.uploadImage;
    data['purpose'] = this.purpose;
    data['contact'] = this.contact;
    data['hr_id'] = this.hrId;
    data['dept_user_id'] = this.deptUserId;
    data['dept_approve_reject_time'] = this.deptApproveRejectTime;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['dept_remarks'] = this.deptRemarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['department_username'] = this.departmentUsername;
    data['security_name'] = this.securityName;
    data['approve_time'] = this.approveTime;
    data['challan_create_time'] = this.challanCreateTime;
    return data;
  }
}
