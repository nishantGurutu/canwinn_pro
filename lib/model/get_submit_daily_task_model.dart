class GetSubmitdailytaskModel {
  bool? status;
  int? completedCount;
  List<SubmitDailyTasksData>? tasks;

  GetSubmitdailytaskModel({this.status, this.completedCount, this.tasks});

  GetSubmitdailytaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    completedCount = json['completed_count'];
    if (json['tasks'] != null) {
      tasks = <SubmitDailyTasksData>[];
      json['tasks'].forEach((v) {
        tasks!.add(new SubmitDailyTasksData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['completed_count'] = this.completedCount;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubmitDailyTasksData {
  int? id;
  int? userId;
  String? taskName;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? doneTime;
  String? remarks;

  SubmitDailyTasksData(
      {this.id,
      this.userId,
      this.taskName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.doneTime,
      this.remarks});

  SubmitDailyTasksData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskName = json['task_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doneTime = json['done_time'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['task_name'] = this.taskName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['done_time'] = this.doneTime;
    data['remarks'] = this.remarks;
    return data;
  }
}
