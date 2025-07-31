class LeadDiscussionListModel {
  bool? status;
  String? message;
  List<LeadDiscussionData>? data;

  LeadDiscussionListModel({this.status, this.message, this.data});

  LeadDiscussionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeadDiscussionData>[];
      json['data'].forEach((v) {
        data!.add(new LeadDiscussionData.fromJson(v));
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

class LeadDiscussionData {
  int? id;
  String? message;
  int? senderId;
  String? senderName;
  String? attachment;
  String? timestamp;

  LeadDiscussionData(
      {this.id,
      this.message,
      this.senderId,
      this.senderName,
      this.attachment,
      this.timestamp});

  LeadDiscussionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    attachment = json['attachment'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['attachment'] = this.attachment;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
