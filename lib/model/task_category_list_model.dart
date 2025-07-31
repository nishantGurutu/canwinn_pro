class TaskCategoryListModel {
  bool? status;
  String? message;
  List<TaskCategoryListData>? data;

  TaskCategoryListModel({this.status, this.message, this.data});

  TaskCategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskCategoryListData>[];
      json['data'].forEach((v) {
        data!.add(new TaskCategoryListData.fromJson(v));
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

class TaskCategoryListData {
  int? id;
  String? categoryName;
  int? status;
  String? createdAt;
  String? updatedAt;

  TaskCategoryListData(
      {this.id,
      this.categoryName,
      this.status,
      this.createdAt,
      this.updatedAt});

  TaskCategoryListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'].toString();
    status = int.parse(json['status'].toString());
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
