class TagListModel {
  bool? status;
  String? message;
  List<TagData>? data;

  TagListModel({this.status, this.message, this.data});

  TagListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TagData>[];
      json['data'].forEach((v) {
        data!.add(new TagData.fromJson(v));
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

class TagData {
  int? id;
  String? tagName;
  int? status;
  String? createdAt;
  String? updatedAt;

  TagData({this.id, this.tagName, this.status, this.createdAt, this.updatedAt});

  TagData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag_name'] = this.tagName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
