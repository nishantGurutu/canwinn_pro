class MeetingAttendeesModel {
  bool? status;
  String? meetingTitle;
  List<Attendees>? attendees;

  MeetingAttendeesModel({this.status, this.meetingTitle, this.attendees});

  MeetingAttendeesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    meetingTitle = json['meeting_title'];
    if (json['attendees'] != null) {
      attendees = <Attendees>[];
      json['attendees'].forEach((v) {
        attendees!.add(new Attendees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['meeting_title'] = this.meetingTitle;
    if (this.attendees != null) {
      data['attendees'] = this.attendees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendees {
  int? id;
  String? name;
  String? image;
  String? joinedDate;
  String? joinedTime;
  dynamic leftDate;
  dynamic leftTime;
  String? status;

  Attendees(
      {this.id,
      this.name,
      this.image,
      this.joinedDate,
      this.joinedTime,
      this.leftDate,
      this.leftTime,
      this.status});

  Attendees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    joinedDate = json['joined_date'];
    joinedTime = json['joined_time'];
    leftDate = json['left_date'];
    leftTime = json['left_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['joined_date'] = this.joinedDate;
    data['joined_time'] = this.joinedTime;
    data['left_date'] = this.leftDate;
    data['left_time'] = this.leftTime;
    data['status'] = this.status;
    return data;
  }
}
