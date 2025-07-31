class TaskListModel {
  List<PreviousTasks>? previousTasks;
  List<TodayTasks>? todayTasks;

  TaskListModel({this.previousTasks, this.todayTasks});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    if (json['previous_tasks'] != null) {
      previousTasks = <PreviousTasks>[];
      json['previous_tasks'].forEach((v) {
        previousTasks!.add(new PreviousTasks.fromJson(v));
      });
    }
    if (json['today_tasks'] != null) {
      todayTasks = <TodayTasks>[];
      json['today_tasks'].forEach((v) {
        todayTasks!.add(new TodayTasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.previousTasks != null) {
      data['previous_tasks'] =
          this.previousTasks!.map((v) => v.toJson()).toList();
    }
    if (this.todayTasks != null) {
      data['today_tasks'] = this.todayTasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PreviousTasks {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  int? departmentId;
  int? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  String? attachment;
  String? dueDate;
  String? dueTime;
  dynamic repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  String? responsiblePersonName;
  String? taskDate;

  PreviousTasks(
      {this.id,
      this.parentId,
      this.userId,
      this.title,
      this.description,
      this.departmentId,
      this.projectId,
      this.assignedTo,
      this.reviewer,
      this.startDate,
      this.attachment,
      this.dueDate,
      this.dueTime,
      this.repeatTask,
      this.priority,
      this.status,
      this.isImportant,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.responsiblePersonName,
      this.taskDate});

  PreviousTasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    departmentId = json['department_id'];
    projectId = json['project_id'];
    assignedTo = json['assigned_to'];
    reviewer = json['reviewer'];
    startDate = json['start_date'];
    attachment = json['attachment'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    repeatTask = json['repeat_task'];
    priority = json['priority'];
    status = json['status'];
    isImportant = json['is_important'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    responsiblePersonName = json['responsible_person_name'];
    taskDate = json['task_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['department_id'] = this.departmentId;
    data['project_id'] = this.projectId;
    data['assigned_to'] = this.assignedTo;
    data['reviewer'] = this.reviewer;
    data['start_date'] = this.startDate;
    data['attachment'] = this.attachment;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['repeat_task'] = this.repeatTask;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['is_important'] = this.isImportant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['responsible_person_name'] = this.responsiblePersonName;
    data['task_date'] = this.taskDate;
    return data;
  }
}

class TodayTasks {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  int? departmentId;
  int? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  String? attachment;
  String? dueDate;
  String? dueTime;
  dynamic repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  String? projectName;
  String? responsiblePersonName;

  TodayTasks(
      {this.id,
      this.parentId,
      this.userId,
      this.title,
      this.description,
      this.departmentId,
      this.projectId,
      this.assignedTo,
      this.reviewer,
      this.startDate,
      this.attachment,
      this.dueDate,
      this.dueTime,
      this.repeatTask,
      this.priority,
      this.status,
      this.isImportant,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.projectName,
      this.responsiblePersonName});

  TodayTasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    departmentId = json['department_id'];
    projectId = json['project_id'];
    assignedTo = json['assigned_to'];
    reviewer = json['reviewer'];
    startDate = json['start_date'];
    attachment = json['attachment'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    repeatTask = json['repeat_task'];
    priority = json['priority'];
    status = json['status'];
    isImportant = json['is_important'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    projectName = json['project_name'];
    responsiblePersonName = json['responsible_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['department_id'] = this.departmentId;
    data['project_id'] = this.projectId;
    data['assigned_to'] = this.assignedTo;
    data['reviewer'] = this.reviewer;
    data['start_date'] = this.startDate;
    data['attachment'] = this.attachment;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['repeat_task'] = this.repeatTask;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['is_important'] = this.isImportant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['project_name'] = this.projectName;
    data['responsible_person_name'] = this.responsiblePersonName;
    return data;
  }
}
