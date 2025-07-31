class SourseListModel {
  bool? status;
  String? message;
  List<SourceListData>? data;

  SourseListModel({this.status, this.message, this.data});

  SourseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SourceListData>[];
      json['data'].forEach((v) {
        data!.add(new SourceListData.fromJson(v));
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

class SourceListData {
  int? id;
  dynamic sourceName;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  SourceListData(
      {this.id, this.sourceName, this.status, this.createdAt, this.updatedAt});

  SourceListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceName = json['source_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source_name'] = this.sourceName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
