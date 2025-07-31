class ChatListModel {
  bool? status;
  List<ChatListData>? data;

  ChatListModel({this.status, this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ChatListData>[];
      json['data'].forEach((v) {
        data!.add(new ChatListData.fromJson(v));
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

class ChatListData {
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
  dynamic groupIcon;
  List<Members>? members;

  ChatListData(
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

  ChatListData.fromJson(Map<String, dynamic> json) {
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
