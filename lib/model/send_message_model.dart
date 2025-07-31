class SendMessageModel {
  bool? status;
  int? chatId;
  Message? message;

  SendMessageModel({this.status, this.chatId, this.message});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    chatId = json['chat_id'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['chat_id'] = this.chatId;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  int? chatId;
  int? senderId;
  String? message;
  String? attachment;
  String? updatedAt;
  String? createdAt;
  int? id;

  Message(
      {this.chatId,
      this.senderId,
      this.message,
      this.attachment,
      this.updatedAt,
      this.createdAt,
      this.id});

  Message.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    message = json['message'];
    attachment = json['attachment'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
