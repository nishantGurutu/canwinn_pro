class ContactStageModel {
  bool? status;
  String? message;
  List<ContactStageData>? data;

  ContactStageModel({this.status, this.message, this.data});

  ContactStageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ContactStageData>[];
      json['data'].forEach((v) {
        data!.add(new ContactStageData.fromJson(v));
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

class ContactStageData {
  int? id;
  String? contactStageName;
  int? status;
  String? createdAt;
  String? updatedAt;

  ContactStageData(
      {this.id,
      this.contactStageName,
      this.status,
      this.createdAt,
      this.updatedAt});

  ContactStageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactStageName = json['contact_stage_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contact_stage_name'] = this.contactStageName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
