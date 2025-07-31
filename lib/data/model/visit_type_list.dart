class LeadVisitTypeListModel {
  bool? status;
  String? message;
  List<VisitTypeData>? data;

  LeadVisitTypeListModel({this.status, this.message, this.data});

  LeadVisitTypeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisitTypeData>[];
      json['data'].forEach((v) {
        data!.add(new VisitTypeData.fromJson(v));
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

class VisitTypeData {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  VisitTypeData(
      {this.id, this.name, this.status, this.createdAt, this.updatedAt});

  VisitTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
