class LeadContactListModel {
  bool? status;
  String? message;
  List<LeadContactData>? data;

  LeadContactListModel({this.status, this.message, this.data});

  LeadContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeadContactData>[];
      json['data'].forEach((v) {
        data!.add(new LeadContactData.fromJson(v));
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

class LeadContactData {
  int? id;
  int? userId;
  int? leadId;
  String? name;
  String? phone;
  String? email;
  String? designation;
  int? status;
  String? createdAt;
  String? updatedAt;

  LeadContactData(
      {this.id,
      this.userId,
      this.leadId,
      this.name,
      this.phone,
      this.email,
      this.designation,
      this.status,
      this.createdAt,
      this.updatedAt});

  LeadContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leadId = json['lead_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    designation = json['designation'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['lead_id'] = this.leadId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['designation'] = this.designation;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
