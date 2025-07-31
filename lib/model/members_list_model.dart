class MembersListModel {
  bool? status;
  List<memberListData>? data;

  MembersListModel({this.status, this.data});

  MembersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <memberListData>[];
      json['data'].forEach((v) {
        data!.add(new memberListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class memberListData {
  int? userId;
  String? name;
  String? email;
  String? image;
  String? role;

  memberListData({this.userId, this.name, this.email, this.image, this.role});

  memberListData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['role'] = this.role;
    return data;
  }
}
