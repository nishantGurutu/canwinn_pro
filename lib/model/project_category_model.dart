class ProjectCategoryListModel {
  bool? status;
  String? message;
  List<ProjectCategoryData>? data;

  ProjectCategoryListModel({this.status, this.message, this.data});

  ProjectCategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProjectCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new ProjectCategoryData.fromJson(v));
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

class ProjectCategoryData {
  int? id;
  String? categoryName;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProjectCategoryData(
      {this.id,
      this.categoryName,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProjectCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
