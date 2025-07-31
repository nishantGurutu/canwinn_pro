class ClientModel {
  bool? status;
  String? message;
  List<ClientData>? data;

  ClientModel({this.status, this.message, this.data});

  ClientModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ClientData>[];
      json['data'].forEach((v) {
        data!.add(new ClientData.fromJson(v));
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

class ClientData {
  int? id;
  int? userId;
  String? companyName;
  String? clientName;
  String? email;
  String? mobile;
  String? gender;
  String? companyAddress;
  String? attachment;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  ClientData(
      {this.id,
      this.userId,
      this.companyName,
      this.clientName,
      this.email,
      this.mobile,
      this.gender,
      this.companyAddress,
      this.attachment,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt});

  ClientData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyName = json['company_name'];
    clientName = json['client_name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    companyAddress = json['company_address'];
    attachment = json['attachment'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_name'] = this.companyName;
    data['client_name'] = this.clientName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['company_address'] = this.companyAddress;
    data['attachment'] = this.attachment;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
