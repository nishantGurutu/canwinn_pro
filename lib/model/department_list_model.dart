class DepartMentListModel {
  bool? status;
  String? message;
  List<DepartmentListData>? data;

  DepartMentListModel({this.status, this.message, this.data});

  DepartMentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DepartmentListData>[];
      json['data'].forEach((v) {
        data!.add(new DepartmentListData.fromJson(v));
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

class DepartmentListData {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  DepartmentListData(
      {this.id, this.name, this.status, this.createdAt, this.updatedAt});

  DepartmentListData.fromJson(Map<String, dynamic> json) {
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
