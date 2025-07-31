class PriorityModel {
  bool? status;
  String? message;
  List<PriorityData>? data;

  PriorityModel({this.status, this.message, this.data});

  PriorityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PriorityData>[];
      json['data'].forEach((v) {
        data!.add(PriorityData.fromJson(v));
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

class PriorityData {
  int? id;
  String? priorityName;
  int? status;
  String? createdAt;
  String? updatedAt;

  PriorityData(
      {this.id,
      this.priorityName,
      this.status,
      this.createdAt,
      this.updatedAt});

  PriorityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    priorityName = json['priority_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['priority_name'] = this.priorityName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
