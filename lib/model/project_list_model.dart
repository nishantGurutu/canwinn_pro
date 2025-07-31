class ProjectListModel {
  bool? status;
  String? message;
  List<AllProjectData>? data;

  ProjectListModel({this.status, this.message, this.data});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllProjectData>[];
      json['data'].forEach((v) {
        data!.add(new AllProjectData.fromJson(v));
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

class AllProjectData {
  int? id;
  String? projectTypeName;
  int? status;
  String? createdAt;
  String? updatedAt;

  AllProjectData(
      {this.id,
      this.projectTypeName,
      this.status,
      this.createdAt,
      this.updatedAt});

  AllProjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectTypeName = json['project_type_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_type_name'] = this.projectTypeName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
