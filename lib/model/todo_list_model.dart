class ToDoModel {
  bool? status;
  String? message;
  List<TodoData>? data;

  ToDoModel({this.status, this.message, this.data});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TodoData>[];
      json['data'].forEach((v) {
        data!.add(new TodoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodoData {
  int? id;
  int? userId;
  String? title;
  String? description;
  int? tags;
  int? priority;
  String? attachment;
  String? alertDate;
  String? alertTime;
  String? reminder;
  int? isImportant;
  int? isDeleted;
  int? isComplete;
  String? createdAt;
  String? updatedAt;

  TodoData(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.tags,
      this.priority,
      this.attachment,
      this.alertDate,
      this.alertTime,
      this.reminder,
      this.isImportant,
      this.isDeleted,
      this.isComplete,
      this.createdAt,
      this.updatedAt});

  TodoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    tags = json['tags'];
    priority = json['priority'];
    attachment = json['attachment'];
    alertDate = json['alert_date'];
    alertTime = json['alert_time'];
    reminder = json['reminder'];
    isImportant = json['is_important'];
    isDeleted = json['is_deleted'];
    isComplete = json['is_complete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['priority'] = this.priority;
    data['attachment'] = this.attachment;
    data['alert_date'] = this.alertDate;
    data['alert_time'] = this.alertTime;
    data['reminder'] = this.reminder;
    data['is_important'] = this.isImportant;
    data['is_deleted'] = this.isDeleted;
    data['is_complete'] = this.isComplete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
