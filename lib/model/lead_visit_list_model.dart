class LeadVisitListModel {
  bool? status;
  String? message;
  List<ListVisitData>? data;

  LeadVisitListModel({this.status, this.message, this.data});

  LeadVisitListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ListVisitData>[];
      json['data'].forEach((v) {
        data!.add(new ListVisitData.fromJson(v));
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

class ListVisitData {
  int? id;
  int? userId;
  int? visitType;
  String? visitorName;
  String? visitorPhone;
  String? visitorEmail;
  String? selfieImage;
  String? address;
  String? latitude;
  String? longitude;
  String? description;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? visitTypeName;

  ListVisitData(
      {this.id,
      this.userId,
      this.visitType,
      this.visitorName,
      this.visitorPhone,
      this.visitorEmail,
      this.selfieImage,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.status,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.visitTypeName});

  ListVisitData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    visitType = json['visit_type'];
    visitorName = json['visitor_name'];
    visitorPhone = json['visitor_phone'];
    visitorEmail = json['visitor_email'];
    selfieImage = json['selfie_image'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    visitTypeName = json['visit_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['visit_type'] = this.visitType;
    data['visitor_name'] = this.visitorName;
    data['visitor_phone'] = this.visitorPhone;
    data['visitor_email'] = this.visitorEmail;
    data['selfie_image'] = this.selfieImage;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['visit_type_name'] = this.visitTypeName;
    return data;
  }
}
