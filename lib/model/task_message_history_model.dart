class TaskMessageHistoryModel {
  bool? status;
  List<TaskMessageData>? data;

  TaskMessageHistoryModel({this.status, this.data});

  TaskMessageHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskMessageData>[];
      json['data'].forEach((v) {
        data!.add(new TaskMessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskMessageData {
  int? id;
  String? message;
  String? attachment;
  int? senderId;
  String? senderName;
  String? senderEmail;
  String? createdAt;
  String? createdDate;

  TaskMessageData(
      {this.id,
      this.message,
      this.attachment,
      this.senderId,
      this.senderName,
      this.senderEmail,
      this.createdAt,
      this.createdDate});

  TaskMessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    attachment = json['attachment'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    senderEmail = json['sender_email'];
    createdAt = json['created_at'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['sender_email'] = this.senderEmail;
    data['created_at'] = this.createdAt;
    data['created_date'] = this.createdDate;
    return data;
  }
}
