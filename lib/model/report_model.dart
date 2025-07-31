class ReportModel {
  bool? status;
  String? message;
  Data? data;

  ReportModel({this.status, this.message, this.data});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalTask;
  int? taskCreatedByMe;
  int? totalTaskAssigned;
  int? dueTodayTask;
  int? completedTask;
  int? progressTask;
  int? newTask;
  int? totalProject;
  int? totalProjectAssigned;
  int? totalCompanies;
  int? totalClients;
  int? avgCompletedTask;
  int? totalUsers;
  Weekly? weekly;

  Data(
      {this.totalTask,
      this.taskCreatedByMe,
      this.totalTaskAssigned,
      this.dueTodayTask,
      this.completedTask,
      this.progressTask,
      this.newTask,
      this.totalProject,
      this.totalProjectAssigned,
      this.totalCompanies,
      this.totalClients,
      this.avgCompletedTask,
      this.totalUsers,
      this.weekly});

  Data.fromJson(Map<String, dynamic> json) {
    totalTask = json['total_task'];
    taskCreatedByMe = json['task_created_by_me'];
    totalTaskAssigned = json['total_task_assigned'];
    dueTodayTask = json['due_today_task'];
    completedTask = json['completed_task'];
    progressTask = json['progress_task'];
    newTask = json['new_task'];
    totalProject = json['total_project'];
    totalProjectAssigned = json['total_project_assigned'];
    totalCompanies = json['total_companies'];
    totalClients = json['total_clients'];
    avgCompletedTask = json['avg_completed_task'];
    totalUsers = json['total_users'];
    weekly =
        json['weekly'] != null ? new Weekly.fromJson(json['weekly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_task'] = this.totalTask;
    data['task_created_by_me'] = this.taskCreatedByMe;
    data['total_task_assigned'] = this.totalTaskAssigned;
    data['due_today_task'] = this.dueTodayTask;
    data['completed_task'] = this.completedTask;
    data['progress_task'] = this.progressTask;
    data['new_task'] = this.newTask;
    data['total_project'] = this.totalProject;
    data['total_project_assigned'] = this.totalProjectAssigned;
    data['total_companies'] = this.totalCompanies;
    data['total_clients'] = this.totalClients;
    data['avg_completed_task'] = this.avgCompletedTask;
    data['total_users'] = this.totalUsers;
    if (this.weekly != null) {
      data['weekly'] = this.weekly!.toJson();
    }
    return data;
  }
}

class Weekly {
  int? sunday;
  int? monday;
  int? tuesday;
  int? wednesday;
  int? thursday;
  int? friday;
  int? saturday;

  Weekly(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  Weekly.fromJson(Map<String, dynamic> json) {
    sunday = json['Sunday'];
    monday = json['Monday'];
    tuesday = json['Tuesday'];
    wednesday = json['Wednesday'];
    thursday = json['Thursday'];
    friday = json['Friday'];
    saturday = json['Saturday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sunday'] = this.sunday;
    data['Monday'] = this.monday;
    data['Tuesday'] = this.tuesday;
    data['Wednesday'] = this.wednesday;
    data['Thursday'] = this.thursday;
    data['Friday'] = this.friday;
    data['Saturday'] = this.saturday;
    return data;
  }
}
