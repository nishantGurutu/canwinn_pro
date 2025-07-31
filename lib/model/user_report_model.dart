class UserReportModel {
  bool? success;
  String? message;
  List<UserReportData>? data;

  UserReportModel({this.success, this.message, this.data});

  UserReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null || json['data'] != "") {
      data = <UserReportData>[];
      json['data'].forEach((v) {
        data!.add(new UserReportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserReportData {
  int? id;
  String? name;
  int? completedTaskCount;
  int? inProgressTaskCount;
  int? newTaskCount;

  UserReportData(
      {this.id,
      this.name,
      this.completedTaskCount,
      this.inProgressTaskCount,
      this.newTaskCount});

  UserReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    completedTaskCount = json['completed_task_count'];
    inProgressTaskCount = json['in_progress_task_count'];
    newTaskCount = json['new_task_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['completed_task_count'] = this.completedTaskCount;
    data['in_progress_task_count'] = this.inProgressTaskCount;
    data['new_task_count'] = this.newTaskCount;
    return data;
  }
}
