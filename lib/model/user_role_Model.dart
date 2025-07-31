class UserRoleListModel {
  bool? status;
  String? message;
  List<UserRoleData>? data;

  UserRoleListModel({this.status, this.message, this.data});

  UserRoleListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserRoleData>[];
      json['data'].forEach((v) {
        data!.add(new UserRoleData.fromJson(v));
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

class UserRoleData {
  int? id;
  String? roleName;
  int? status;
  String? createdAt;
  String? updatedAt;

  UserRoleData(
      {this.id, this.roleName, this.status, this.createdAt, this.updatedAt});

  UserRoleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['role_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_name'] = this.roleName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
