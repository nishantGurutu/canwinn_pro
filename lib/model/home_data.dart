class HomeDataModel {
  bool? status;
  String? message;
  Data? data;

  HomeDataModel({this.status, this.message, this.data});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
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
  int? totalTaskAssigned;
  int? taskCreatedByMe;
  int? dueTodayTask;
  int? totalProjectsDueToday;
  int? totalTasksPastDue;
  int? totalProjectsPastDue;
  int? completedTask;
  int? progressTask;
  int? newTask;
  int? totalProject;
  int? totalProjectAssigned;
  int? totalCompanies;
  int? totalClients;
  double? avgTaskCreated;
  double? avgTaskAssigned;
  int? avgTaskDue;
  int? avgCompletedTask;
  int? totalUsers;
  int? avgTaskPastDue;

  Data(
      {this.totalTask,
      this.totalTaskAssigned,
      this.taskCreatedByMe,
      this.dueTodayTask,
      this.totalProjectsDueToday,
      this.totalTasksPastDue,
      this.totalProjectsPastDue,
      this.completedTask,
      this.progressTask,
      this.newTask,
      this.totalProject,
      this.totalProjectAssigned,
      this.totalCompanies,
      this.totalClients,
      this.avgTaskCreated,
      this.avgTaskAssigned,
      this.avgTaskDue,
      this.avgCompletedTask,
      this.totalUsers,
      this.avgTaskPastDue});

  Data.fromJson(Map<String, dynamic> json) {
    totalTask = json['total_task'];
    totalTaskAssigned = json['total_task_assigned'];
    taskCreatedByMe = json['task_created_by_me'];
    dueTodayTask = json['due_today_task'];
    totalProjectsDueToday = json['total_projects_due_today'];
    totalTasksPastDue = json['total_tasks_past_due'];
    totalProjectsPastDue = json['total_projects_past_due'];
    completedTask = json['completed_task'];
    progressTask = json['progress_task'];
    newTask = json['new_task'];
    totalProject = json['total_project'];
    totalProjectAssigned = json['total_project_assigned'];
    totalCompanies = json['total_companies'];
    totalClients = json['total_clients'];
    avgTaskCreated = json['avg_task_created'];
    avgTaskAssigned = json['avg_task_assigned'];
    avgTaskDue = json['avg_task_due'];
    avgCompletedTask = json['avg_completed_task'];
    totalUsers = json['total_users'];
    avgTaskPastDue = json['avg_task_past_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_task'] = this.totalTask;
    data['total_task_assigned'] = this.totalTaskAssigned;
    data['task_created_by_me'] = this.taskCreatedByMe;
    data['due_today_task'] = this.dueTodayTask;
    data['total_projects_due_today'] = this.totalProjectsDueToday;
    data['total_tasks_past_due'] = this.totalTasksPastDue;
    data['total_projects_past_due'] = this.totalProjectsPastDue;
    data['completed_task'] = this.completedTask;
    data['progress_task'] = this.progressTask;
    data['new_task'] = this.newTask;
    data['total_project'] = this.totalProject;
    data['total_project_assigned'] = this.totalProjectAssigned;
    data['total_companies'] = this.totalCompanies;
    data['total_clients'] = this.totalClients;
    data['avg_task_created'] = this.avgTaskCreated;
    data['avg_task_assigned'] = this.avgTaskAssigned;
    data['avg_task_due'] = this.avgTaskDue;
    data['avg_completed_task'] = this.avgCompletedTask;
    data['total_users'] = this.totalUsers;
    data['avg_task_past_due'] = this.avgTaskPastDue;
    return data;
  }
}
