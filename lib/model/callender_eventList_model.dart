class EventCallenderListModel {
  bool? status;
  String? message;
  List<CallenderEventData>? data;

  EventCallenderListModel({this.status, this.message, this.data});

  EventCallenderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CallenderEventData>[];
      json['data'].forEach((v) {
        data!.add(new CallenderEventData.fromJson(v));
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

class CallenderEventData {
  int? id;
  int? userId;
  String? eventName;
  String? eventDate;
  String? eventTime;
  String? reminder;
  int? status;
  String? createdAt;
  String? updatedAt;

  CallenderEventData(
      {this.id,
      this.userId,
      this.eventName,
      this.eventDate,
      this.eventTime,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt});

  CallenderEventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventName = json['event_name'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['event_name'] = this.eventName;
    data['event_date'] = this.eventDate;
    data['event_time'] = this.eventTime;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
