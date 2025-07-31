class HomeScreenDataModel {
  bool? status;
  String? message;
  Data? data;

  HomeScreenDataModel({this.status, this.message, this.data});

  HomeScreenDataModel.fromJson(Map<String, dynamic> json) {
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
  int? avgTaskCreated;
  double? avgTaskAssigned;
  int? avgTaskDue;
  int? avgCompletedTask;
  int? totalUsers;
  int? avgTaskPastDue;
  List<Chatlist>? chatlist;
  List<Tasklist>? tasklist;
  int? totalTaskAssignedHigh;
  int? totalTaskAssignedMedium;
  int? totalTaskAssignedLow;
  List<Taskscomments>? taskscomments;

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
      this.avgTaskPastDue,
      this.chatlist,
      this.tasklist,
      this.totalTaskAssignedHigh,
      this.totalTaskAssignedMedium,
      this.totalTaskAssignedLow,
      this.taskscomments});

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
    if (json['chatlist'] != null) {
      chatlist = <Chatlist>[];
      json['chatlist'].forEach((v) {
        chatlist!.add(new Chatlist.fromJson(v));
      });
    }
    if (json['tasklist'] != null) {
      tasklist = <Tasklist>[];
      json['tasklist'].forEach((v) {
        tasklist!.add(new Tasklist.fromJson(v));
      });
    }
    totalTaskAssignedHigh = json['total_task_assigned_high'];
    totalTaskAssignedMedium = json['total_task_assigned_medium'];
    totalTaskAssignedLow = json['total_task_assigned_low'];
    if (json['taskscomments'] != null) {
      taskscomments = <Taskscomments>[];
      json['taskscomments'].forEach((v) {
        taskscomments!.add(new Taskscomments.fromJson(v));
      });
    }
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
    if (this.chatlist != null) {
      data['chatlist'] = this.chatlist!.map((v) => v.toJson()).toList();
    }
    if (this.tasklist != null) {
      data['tasklist'] = this.tasklist!.map((v) => v.toJson()).toList();
    }
    data['total_task_assigned_high'] = this.totalTaskAssignedHigh;
    data['total_task_assigned_medium'] = this.totalTaskAssignedMedium;
    data['total_task_assigned_low'] = this.totalTaskAssignedLow;
    if (this.taskscomments != null) {
      data['taskscomments'] =
          this.taskscomments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chatlist {
  int? chatId;
  String? type;
  int? userId;
  String? name;
  String? email;
  String? image;
  String? lastMessage;
  String? lastMessageTime;
  String? lastMessageDate;
  int? unseenMessages;
  bool? isToday;
  String? groupIcon;
  List<Members>? members;

  Chatlist(
      {this.chatId,
      this.type,
      this.userId,
      this.name,
      this.email,
      this.image,
      this.lastMessage,
      this.lastMessageTime,
      this.lastMessageDate,
      this.unseenMessages,
      this.isToday,
      this.groupIcon,
      this.members});

  Chatlist.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    type = json['type'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    lastMessage = json['last_message'];
    lastMessageTime = json['last_message_time'];
    lastMessageDate = json['last_message_date'];
    unseenMessages = json['unseen_messages'];
    isToday = json['is_today'];
    groupIcon = json['group_icon'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['last_message'] = this.lastMessage;
    data['last_message_time'] = this.lastMessageTime;
    data['last_message_date'] = this.lastMessageDate;
    data['unseen_messages'] = this.unseenMessages;
    data['is_today'] = this.isToday;
    data['group_icon'] = this.groupIcon;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int? userId;
  String? name;
  String? image;
  String? role;

  Members({this.userId, this.name, this.image, this.role});

  Members.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['role'] = this.role;
    return data;
  }
}

class Tasklist {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  int? departmentId;
  String? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  String? attachment;
  String? dueDate;
  String? dueTime;
  Null repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  dynamic projectName;
  String? departmentName;
  String? creatorName;
  String? taskDate;
  String? taskTime;
  int? progressStatus;
  String? progressRemarks;
  String? progressUpdatedAt;
  int? isSubtaskCompleted;
  int? isLateCompleted;
  String? assignedUserStatus;
  String? creatorReviewerStatus;
  String? effectiveStatus;

  Tasklist(
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
      this.departmentName,
      this.creatorName,
      this.taskDate,
      this.taskTime,
      this.progressStatus,
      this.progressRemarks,
      this.progressUpdatedAt,
      this.isSubtaskCompleted,
      this.isLateCompleted,
      this.assignedUserStatus,
      this.creatorReviewerStatus,
      this.effectiveStatus});

  Tasklist.fromJson(Map<String, dynamic> json) {
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
    departmentName = json['department_name'];
    creatorName = json['creator_name'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    progressStatus = json['progress_status'];
    progressRemarks = json['progress_remarks'];
    progressUpdatedAt = json['progress_updated_at'];
    isSubtaskCompleted = json['is_subtask_completed'];
    isLateCompleted = json['is_late_completed'];
    assignedUserStatus = json['assigned_user_status'];
    creatorReviewerStatus = json['creator_reviewer_status'];
    effectiveStatus = json['effective_status'];
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
    data['department_name'] = this.departmentName;
    data['creator_name'] = this.creatorName;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['progress_status'] = this.progressStatus;
    data['progress_remarks'] = this.progressRemarks;
    data['progress_updated_at'] = this.progressUpdatedAt;
    data['is_subtask_completed'] = this.isSubtaskCompleted;
    data['is_late_completed'] = this.isLateCompleted;
    data['assigned_user_status'] = this.assignedUserStatus;
    data['creator_reviewer_status'] = this.creatorReviewerStatus;
    data['effective_status'] = this.effectiveStatus;
    return data;
  }
}

class Taskscomments {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  int? departmentId;
  String? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  dynamic attachment;
  String? dueDate;
  String? dueTime;
  dynamic repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  List<Comments>? comments;

  Taskscomments(
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
      this.comments});

  Taskscomments.fromJson(Map<String, dynamic> json) {
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
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
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
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int? id;
  int? taskId;
  int? userId;
  String? comment;
  dynamic attachment;
  int? status;
  String? createdAt;
  String? updatedAt;

  Comments(
      {this.id,
      this.taskId,
      this.userId,
      this.comment,
      this.attachment,
      this.status,
      this.createdAt,
      this.updatedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    comment = json['comment'];
    attachment = json['attachment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['attachment'] = this.attachment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
