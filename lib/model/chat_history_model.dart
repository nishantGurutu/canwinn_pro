class ChatHistoryModel {
  bool? status;
  List<ChatHistoryData>? data;

  ChatHistoryModel({this.status, this.data});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ChatHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new ChatHistoryData.fromJson(v));
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

class ChatHistoryData {
  int? id;
  String? message;
  int? parentMessageId;
  String? attachment;
  int? senderId;
  String? senderName;
  String? senderEmail;
  String? senderImage;
  String? createdAt;
  String? createdDate;
  int? parentSenderId;
  String? parentSenderName;
  String? parentMessage;

  ChatHistoryData(
      {this.id,
      this.message,
      this.parentMessageId,
      this.attachment,
      this.senderId,
      this.senderName,
      this.senderEmail,
      this.senderImage,
      this.createdAt,
      this.createdDate,
      this.parentSenderId,
      this.parentSenderName,
      this.parentMessage});

  ChatHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    parentMessageId = json['parent_message_id'];
    attachment = json['attachment'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    senderEmail = json['sender_email'];
    senderImage = json['sender_image'];
    createdAt = json['created_at'];
    createdDate = json['created_date'];
    parentSenderId = json['parent_sender_id'];
    parentSenderName = json['parent_sender_name'];
    parentMessage = json['parent_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['parent_message_id'] = this.parentMessageId;
    data['attachment'] = this.attachment;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['sender_email'] = this.senderEmail;
    data['sender_image'] = this.senderImage;
    data['created_at'] = this.createdAt;
    data['created_date'] = this.createdDate;
    data['parent_sender_id'] = this.parentSenderId;
    data['parent_sender_name'] = this.parentSenderName;
    data['parent_message'] = this.parentMessage;
    return data;
  }
}
