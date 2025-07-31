class ProjectDetailsModel {
  bool? status;
  String? message;
  ProjectDetailsData? data;

  ProjectDetailsModel({this.status, this.message, this.data});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProjectDetailsData.fromJson(json['data'])
        : null;
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

class ProjectDetailsData {
  int? id;
  int? userId;
  String? departmentId;
  String? name;
  int? type;
  int? client;
  int? category;
  String? projectTiming;
  String? price;
  String? amount;
  String? total;
  String? responsiblePerson;
  int? teamLeader;
  String? startDate;
  String? dueDate;
  int? priority;
  int? status;
  String? description;
  dynamic pipelineStage;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  String? projectName;
  String? departmentName;
  String? taskDate;
  String? assignedUsers;
  String? assignedDepartments;

  ProjectDetailsData(
      {this.id,
      this.userId,
      this.departmentId,
      this.name,
      this.type,
      this.client,
      this.category,
      this.projectTiming,
      this.price,
      this.amount,
      this.total,
      this.responsiblePerson,
      this.teamLeader,
      this.startDate,
      this.dueDate,
      this.priority,
      this.status,
      this.description,
      this.pipelineStage,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.projectName,
      this.departmentName,
      this.taskDate,
      this.assignedUsers,
      this.assignedDepartments});

  ProjectDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    name = json['name'];
    type = json['type'];
    client = json['client'];
    category = json['category'];
    projectTiming = json['project_timing'];
    price = json['price'];
    amount = json['amount'];
    total = json['total'];
    responsiblePerson = json['responsible_person'];
    teamLeader = json['team_leader'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    priority = json['priority'];
    status = json['status'];
    description = json['description'];
    pipelineStage = json['pipeline_stage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    projectName = json['project_name'];
    departmentName = json['department_name'];
    taskDate = json['task_date'];
    assignedUsers = json['assigned_users'];
    assignedDepartments = json['assigned_departments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['department_id'] = this.departmentId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['client'] = this.client;
    data['category'] = this.category;
    data['project_timing'] = this.projectTiming;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['total'] = this.total;
    data['responsible_person'] = this.responsiblePerson;
    data['team_leader'] = this.teamLeader;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['description'] = this.description;
    data['pipeline_stage'] = this.pipelineStage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['project_name'] = this.projectName;
    data['department_name'] = this.departmentName;
    data['task_date'] = this.taskDate;
    data['assigned_users'] = this.assignedUsers;
    data['assigned_departments'] = this.assignedDepartments;
    return data;
  }
}
