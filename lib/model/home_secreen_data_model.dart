class HomeScreenHomeScreenDataModel {
  bool? status;
  String? message;
  HomeScreenData? data;

  HomeScreenHomeScreenDataModel({this.status, this.message, this.data});

  HomeScreenHomeScreenDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new HomeScreenData.fromJson(json['data']) : null;
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

class HomeScreenData {
  dynamic totalTask;
  dynamic totalTaskAssigned;
  dynamic taskCreatedByMe;
  dynamic dueTodayTask;
  dynamic totalTasksPastDue;
  dynamic completedTask;
  dynamic progressTask;
  dynamic newTask;
  dynamic totalUsers;
  List<Chatlist>? chatlist;
  List<Tasklist>? tasklist;
  dynamic totalTaskAssignedHigh;
  dynamic totalTaskAssignedMedium;
  dynamic totalTaskAssignedLow;
  List<LatestComments>? latestComments;
  List<HomePinnedNotes>? pinnedNotes;
  dynamic todoCount;
  dynamic pendingMeetings;
  List<HomeUsers>? users;

  HomeScreenData(
      {this.totalTask,
      this.totalTaskAssigned,
      this.taskCreatedByMe,
      this.dueTodayTask,
      this.totalTasksPastDue,
      this.completedTask,
      this.progressTask,
      this.newTask,
      this.totalUsers,
      this.chatlist,
      this.tasklist,
      this.totalTaskAssignedHigh,
      this.totalTaskAssignedMedium,
      this.totalTaskAssignedLow,
      this.latestComments,
      this.pinnedNotes,
      this.todoCount,
      this.pendingMeetings,
      this.users});

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    totalTask = json['total_task'];
    totalTaskAssigned = json['total_task_assigned'];
    taskCreatedByMe = json['task_created_by_me'];
    dueTodayTask = json['due_today_task'];
    totalTasksPastDue = json['total_tasks_past_due'];
    completedTask = json['completed_task'];
    progressTask = json['progress_task'];
    newTask = json['new_task'];
    totalUsers = json['total_users'];
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
    if (json['latestComments'] != null) {
      latestComments = <LatestComments>[];
      json['latestComments'].forEach((v) {
        latestComments!.add(new LatestComments.fromJson(v));
      });
    }
    if (json['pinnedNotes'] != null) {
      pinnedNotes = <HomePinnedNotes>[];
      json['pinnedNotes'].forEach((v) {
        pinnedNotes!.add(new HomePinnedNotes.fromJson(v));
      });
    }
    todoCount = json['todoCount'];
    pendingMeetings = json['pendingMeetings'];
    if (json['users'] != null && json['users'] != "") {
      users = <HomeUsers>[];
      json['users'].forEach((v) {
        users!.add(new HomeUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_task'] = this.totalTask;
    data['total_task_assigned'] = this.totalTaskAssigned;
    data['task_created_by_me'] = this.taskCreatedByMe;
    data['due_today_task'] = this.dueTodayTask;
    data['total_tasks_past_due'] = this.totalTasksPastDue;
    data['completed_task'] = this.completedTask;
    data['progress_task'] = this.progressTask;
    data['new_task'] = this.newTask;
    data['total_users'] = this.totalUsers;
    if (this.chatlist != null) {
      data['chatlist'] = this.chatlist!.map((v) => v.toJson()).toList();
    }
    if (this.tasklist != null) {
      data['tasklist'] = this.tasklist!.map((v) => v.toJson()).toList();
    }
    data['total_task_assigned_high'] = this.totalTaskAssignedHigh;
    data['total_task_assigned_medium'] = this.totalTaskAssignedMedium;
    data['total_task_assigned_low'] = this.totalTaskAssignedLow;
    if (this.latestComments != null) {
      data['latestComments'] =
          this.latestComments!.map((v) => v.toJson()).toList();
    }
    if (this.pinnedNotes != null) {
      data['pinnedNotes'] = this.pinnedNotes!.map((v) => v.toJson()).toList();
    }
    data['todoCount'] = this.todoCount;
    data['pendingMeetings'] = this.pendingMeetings;
    if (this.users != null && this.users != '') {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chatlist {
  dynamic chatId;
  dynamic type;
  dynamic userId;
  dynamic name;
  dynamic email;
  dynamic lastMessage;
  dynamic lastMessageTime;
  dynamic lastMessageDate;
  dynamic unseenMessages;
  dynamic isToday;

  Chatlist(
      {this.chatId,
      this.type,
      this.userId,
      this.name,
      this.email,
      this.lastMessage,
      this.lastMessageTime,
      this.lastMessageDate,
      this.unseenMessages,
      this.isToday});

  Chatlist.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    type = json['type'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    lastMessage = json['last_message'];
    lastMessageTime = json['last_message_time'];
    lastMessageDate = json['last_message_date'];
    unseenMessages = json['unseen_messages'];
    isToday = json['is_today'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['last_message'] = this.lastMessage;
    data['last_message_time'] = this.lastMessageTime;
    data['last_message_date'] = this.lastMessageDate;
    data['unseen_messages'] = this.unseenMessages;
    data['is_today'] = this.isToday;
    return data;
  }
}

class Tasklist {
  dynamic id;
  dynamic parentId;
  dynamic userId;
  dynamic title;
  dynamic description;
  dynamic departmentId;
  dynamic projectId;
  dynamic assignedTo;
  dynamic reviewer;
  dynamic startDate;
  dynamic attachment;
  dynamic dueDate;
  dynamic dueTime;
  dynamic repeatTask;
  dynamic priority;
  dynamic status;
  dynamic isImportant;
  dynamic reminder;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic priorityName;
  dynamic projectName;
  dynamic departmentName;
  dynamic creatorName;
  dynamic taskDate;
  dynamic taskTime;
  dynamic progressStatus;
  dynamic progressRemarks;
  dynamic progressUpdatedAt;
  dynamic isSubtaskCompleted;
  dynamic isLateCompleted;
  dynamic assignedUserStatus;
  dynamic creatorReviewerStatus;
  dynamic effectiveStatus;

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
      this.reminder,
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
    reminder = json['reminder'];
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
    data['reminder'] = this.reminder;
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

class LatestComments {
  dynamic taskId;
  dynamic taskTitle;
  dynamic message;
  dynamic messageDate;
  dynamic senderName;

  LatestComments(
      {this.taskId,
      this.taskTitle,
      this.message,
      this.messageDate,
      this.senderName});

  LatestComments.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskTitle = json['task_title'];
    message = json['message'];
    messageDate = json['message_date'];
    senderName = json['sender_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_title'] = this.taskTitle;
    data['message'] = this.message;
    data['message_date'] = this.messageDate;
    data['sender_name'] = this.senderName;
    return data;
  }
}

class HomePinnedNotes {
  dynamic id;
  dynamic folderId;
  dynamic userId;
  dynamic title;
  dynamic color;
  dynamic description;
  dynamic tags;
  dynamic priority;
  dynamic attachment;
  dynamic isImportant;
  dynamic isDeleted;
  dynamic createdAt;
  dynamic updatedAt;

  HomePinnedNotes(
      {this.id,
      this.folderId,
      this.userId,
      this.title,
      this.color,
      this.description,
      this.tags,
      this.priority,
      this.attachment,
      this.isImportant,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  HomePinnedNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folderId = json['folder_id'];
    userId = json['user_id'];
    title = json['title'];
    color = json['color'];
    description = json['description'];
    tags = json['tags'];
    priority = json['priority'];
    attachment = json['attachment'];
    isImportant = json['is_important'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['folder_id'] = this.folderId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['color'] = this.color;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['priority'] = this.priority;
    data['attachment'] = this.attachment;
    data['is_important'] = this.isImportant;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class HomeUsers {
  dynamic id;
  dynamic name;
  dynamic completedTaskCount;
  dynamic inProgressTaskCount;
  dynamic newTaskCount;

  HomeUsers(
      {this.id,
      this.name,
      this.completedTaskCount,
      this.inProgressTaskCount,
      this.newTaskCount});

  HomeUsers.fromJson(Map<String, dynamic> json) {
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
