class PreviousSubmittedTaskModel {
  bool? status;
  List<Tasks>? tasks;

  PreviousSubmittedTaskModel({this.status, this.tasks});

  PreviousSubmittedTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? timeId;
  String? taskName;
  String? doneTime;
  String? createdAt;

  Tasks({this.timeId, this.taskName, this.doneTime, this.createdAt});

  Tasks.fromJson(Map<String, dynamic> json) {
    timeId = json['time_id'];
    taskName = json['task_name'];
    doneTime = json['done_time'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_id'] = this.timeId;
    data['task_name'] = this.taskName;
    data['done_time'] = this.doneTime;
    data['created_at'] = this.createdAt;
    return data;
  }
}
