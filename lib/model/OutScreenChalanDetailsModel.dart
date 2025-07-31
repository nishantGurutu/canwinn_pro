class OutScreenChalanDetailsModel {
  bool? status;
  String? message;
  Data? data;

  OutScreenChalanDetailsModel({this.status, this.message, this.data});

  OutScreenChalanDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? departmentName;
  String? dispatchTo;
  String? contact;
  String? uploadImagePath;
  Null departmentUploadImage;
  String? securityUploadImage;
  String? preparedBy;
  String? approvedBy;
  String? receivedBy;
  Null authorisedBy;
  Null preparedBySignature;
  Null approvedBySignature;
  Null receivedBySignature;
  Null authorisedBySignature;
  int? status;
  int? securityId;
  int? hrId;
  Null remarks;
  Null deptRemarks;
  String? hrApproveRejectTime;
  String? createdAt;
  String? updatedAt;
  String? challanCreateTime;
  String? outTime;
  List<Items>? items;

  Data(
      {this.id,
      this.userId,
      this.challanNumber,
      this.date,
      this.departmentName,
      this.dispatchTo,
      this.contact,
      this.uploadImagePath,
      this.departmentUploadImage,
      this.securityUploadImage,
      this.preparedBy,
      this.approvedBy,
      this.receivedBy,
      this.authorisedBy,
      this.preparedBySignature,
      this.approvedBySignature,
      this.receivedBySignature,
      this.authorisedBySignature,
      this.status,
      this.securityId,
      this.hrId,
      this.remarks,
      this.deptRemarks,
      this.hrApproveRejectTime,
      this.createdAt,
      this.updatedAt,
      this.challanCreateTime,
      this.outTime,
      this.items});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    challanNumber = json['challan_number'];
    date = json['date'];
    departmentName = json['department_name'];
    dispatchTo = json['dispatch_to'];
    contact = json['contact'];
    uploadImagePath = json['upload_image_path'];
    departmentUploadImage = json['department_upload_image'];
    securityUploadImage = json['security_upload_image'];
    preparedBy = json['prepared_by'];
    approvedBy = json['approved_by'];
    receivedBy = json['received_by'];
    authorisedBy = json['authorised_by'];
    preparedBySignature = json['prepared_by_signature'];
    approvedBySignature = json['approved_by_signature'];
    receivedBySignature = json['received_by_signature'];
    authorisedBySignature = json['authorised_by_signature'];
    status = json['status'];
    securityId = json['security_id'];
    hrId = json['hr_id'];
    remarks = json['remarks'];
    deptRemarks = json['dept_remarks'];
    hrApproveRejectTime = json['hr_approve_reject_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    challanCreateTime = json['challan_create_time'];
    outTime = json['out_time'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['challan_number'] = this.challanNumber;
    data['date'] = this.date;
    data['department_name'] = this.departmentName;
    data['dispatch_to'] = this.dispatchTo;
    data['contact'] = this.contact;
    data['upload_image_path'] = this.uploadImagePath;
    data['department_upload_image'] = this.departmentUploadImage;
    data['security_upload_image'] = this.securityUploadImage;
    data['prepared_by'] = this.preparedBy;
    data['approved_by'] = this.approvedBy;
    data['received_by'] = this.receivedBy;
    data['authorised_by'] = this.authorisedBy;
    data['prepared_by_signature'] = this.preparedBySignature;
    data['approved_by_signature'] = this.approvedBySignature;
    data['received_by_signature'] = this.receivedBySignature;
    data['authorised_by_signature'] = this.authorisedBySignature;
    data['status'] = this.status;
    data['security_id'] = this.securityId;
    data['hr_id'] = this.hrId;
    data['remarks'] = this.remarks;
    data['dept_remarks'] = this.deptRemarks;
    data['hr_approve_reject_time'] = this.hrApproveRejectTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['challan_create_time'] = this.challanCreateTime;
    data['out_time'] = this.outTime;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? challanId;
  String? itemName;
  int? isReturnable;
  int? quantity;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
      this.challanId,
      this.itemName,
      this.isReturnable,
      this.quantity,
      this.remarks,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    challanId = json['challan_id'];
    itemName = json['item_name'];
    isReturnable = json['is_returnable'];
    quantity = json['quantity'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['challan_id'] = this.challanId;
    data['item_name'] = this.itemName;
    data['is_returnable'] = this.isReturnable;
    data['quantity'] = this.quantity;
    data['remarks'] = this.remarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
