class DailyTaskListModel {
  bool? status;
  String? message;
  int? completedCount;
  List<DailyTasks>? tasks;

  DailyTaskListModel(
      {this.status, this.message, this.completedCount, this.tasks});

  DailyTaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    completedCount = json['completed_count'];
    if (json['tasks'] != null) {
      tasks = <DailyTasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new DailyTasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['completed_count'] = this.completedCount;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyTasks {
  int? id;
  int? userId;
  String? taskName;
  String? taskTime;
  int? status;
  String? createdAt;
  String? updatedAt;

  DailyTasks(
      {this.id,
      this.userId,
      this.taskName,
      this.taskTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  DailyTasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskName = json['task_name'];
    taskTime = json['task_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['task_name'] = this.taskName;
    data['task_time'] = this.taskTime;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
