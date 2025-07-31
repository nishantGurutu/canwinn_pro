class ProjectTimingModel {
  bool? status;
  String? message;
  List<ProjectTimingData>? data;

  ProjectTimingModel({this.status, this.message, this.data});

  ProjectTimingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProjectTimingData>[];
      json['data'].forEach((v) {
        data!.add(new ProjectTimingData.fromJson(v));
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

class ProjectTimingData {
  int? id;
  String? timingName;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProjectTimingData(
      {this.id, this.timingName, this.status, this.createdAt, this.updatedAt});

  ProjectTimingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timingName = json['timing_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timing_name'] = this.timingName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
