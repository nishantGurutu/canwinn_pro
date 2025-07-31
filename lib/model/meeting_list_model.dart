class MeetingListModel {
  bool? status;
  String? message;
  List<OngoingMeeting>? ongoing;
  List<DoneMeeting>? done;
  List<UpcomingMeeting>? upcoming;

  MeetingListModel(
      {this.status, this.message, this.ongoing, this.done, this.upcoming});

  MeetingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['ongoing'] != null) {
      ongoing = <OngoingMeeting>[];
      json['ongoing'].forEach((v) {
        ongoing!.add(new OngoingMeeting.fromJson(v));
      });
    }
    if (json['done'] != null) {
      done = <DoneMeeting>[];
      json['done'].forEach((v) {
        done!.add(new DoneMeeting.fromJson(v));
      });
    }
    if (json['upcoming'] != null) {
      upcoming = <UpcomingMeeting>[];
      json['upcoming'].forEach((v) {
        upcoming!.add(new UpcomingMeeting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.ongoing != null) {
      data['ongoing'] = this.ongoing!.map((v) => v.toJson()).toList();
    }
    if (this.done != null) {
      data['done'] = this.done!.map((v) => v.toJson()).toList();
    }
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OngoingMeeting {
  int? id;
  int? userId;
  String? deptId;
  String? users;
  String? title;
  String? venue;
  String? meetingDate;
  String? meetingTime;
  String? meetingEndTime;
  String? url;
  String? reminder;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? attendanceStatus;
  List<AttendingUsers>? attendingUsers;
  List<Moms>? moms;

  OngoingMeeting(
      {this.id,
      this.userId,
      this.deptId,
      this.users,
      this.title,
      this.venue,
      this.meetingDate,
      this.meetingTime,
      this.meetingEndTime,
      this.url,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.attendanceStatus,
      this.attendingUsers,
      this.moms});

  OngoingMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deptId = json['dept_id'];
    users = json['users'];
    title = json['title'];
    venue = json['venue'];
    meetingDate = json['meeting_date'];
    meetingTime = json['meeting_time'];
    meetingEndTime = json['meeting_end_time'];
    url = json['url'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attendanceStatus = json['attendance_status'];
    if (json['attending_users'] != null) {
      attendingUsers = <AttendingUsers>[];
      json['attending_users'].forEach((v) {
        attendingUsers!.add(new AttendingUsers.fromJson(v));
      });
    }
    if (json['moms'] != null) {
      moms = <Moms>[];
      json['moms'].forEach((v) {
        moms!.add(new Moms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dept_id'] = this.deptId;
    data['users'] = this.users;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['meeting_date'] = this.meetingDate;
    data['meeting_time'] = this.meetingTime;
    data['meeting_end_time'] = this.meetingEndTime;
    data['url'] = this.url;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attendance_status'] = this.attendanceStatus;
    if (this.attendingUsers != null) {
      data['attending_users'] =
          this.attendingUsers!.map((v) => v.toJson()).toList();
    }
    if (this.moms != null) {
      data['moms'] = this.moms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoneMeeting {
  int? id;
  int? userId;
  String? deptId;
  String? users;
  String? title;
  String? venue;
  String? meetingDate;
  String? meetingTime;
  String? meetingEndTime;
  String? url;
  String? reminder;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? attendanceStatus;
  List<AttendingUsers>? attendingUsers;
  List<Moms>? moms;

  DoneMeeting(
      {this.id,
      this.userId,
      this.deptId,
      this.users,
      this.title,
      this.venue,
      this.meetingDate,
      this.meetingTime,
      this.meetingEndTime,
      this.url,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.attendanceStatus,
      this.attendingUsers,
      this.moms});

  DoneMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deptId = json['dept_id'];
    users = json['users'];
    title = json['title'];
    venue = json['venue'];
    meetingDate = json['meeting_date'];
    meetingTime = json['meeting_time'];
    meetingEndTime = json['meeting_end_time'];
    url = json['url'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attendanceStatus = json['attendance_status'];
    if (json['attending_users'] != null) {
      attendingUsers = <AttendingUsers>[];
      json['attending_users'].forEach((v) {
        attendingUsers!.add(new AttendingUsers.fromJson(v));
      });
    }
    if (json['moms'] != null) {
      moms = <Moms>[];
      json['moms'].forEach((v) {
        moms!.add(new Moms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dept_id'] = this.deptId;
    data['users'] = this.users;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['meeting_date'] = this.meetingDate;
    data['meeting_time'] = this.meetingTime;
    data['meeting_end_time'] = this.meetingEndTime;
    data['url'] = this.url;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attendance_status'] = this.attendanceStatus;
    if (this.attendingUsers != null) {
      data['attending_users'] =
          this.attendingUsers!.map((v) => v.toJson()).toList();
    }
    if (this.moms != null) {
      data['moms'] = this.moms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingMeeting {
  int? id;
  int? userId;
  String? deptId;
  String? users;
  String? title;
  String? venue;
  String? meetingDate;
  String? meetingTime;
  String? meetingEndTime;
  String? url;
  String? reminder;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? attendanceStatus;
  List<AttendingUsers>? attendingUsers;
  List<Moms>? moms;

  UpcomingMeeting(
      {this.id,
      this.userId,
      this.deptId,
      this.users,
      this.title,
      this.venue,
      this.meetingDate,
      this.meetingTime,
      this.meetingEndTime,
      this.url,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.attendanceStatus,
      this.attendingUsers,
      this.moms});

  UpcomingMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deptId = json['dept_id'];
    users = json['users'];
    title = json['title'];
    venue = json['venue'];
    meetingDate = json['meeting_date'];
    meetingTime = json['meeting_time'];
    meetingEndTime = json['meeting_end_time'];
    url = json['url'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attendanceStatus = json['attendance_status'];
    if (json['attending_users'] != null) {
      attendingUsers = <AttendingUsers>[];
      json['attending_users'].forEach((v) {
        attendingUsers!.add(new AttendingUsers.fromJson(v));
      });
    }
    if (json['moms'] != null) {
      moms = <Moms>[];
      json['moms'].forEach((v) {
        moms!.add(new Moms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dept_id'] = this.deptId;
    data['users'] = this.users;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['meeting_date'] = this.meetingDate;
    data['meeting_time'] = this.meetingTime;
    data['meeting_end_time'] = this.meetingEndTime;
    data['url'] = this.url;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attendance_status'] = this.attendanceStatus;
    if (this.attendingUsers != null) {
      data['attending_users'] =
          this.attendingUsers!.map((v) => v.toJson()).toList();
    }
    if (this.moms != null) {
      data['moms'] = this.moms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendingUsers {
  int? id;
  String? name;
  String? image;

  AttendingUsers({this.id, this.name, this.image});

  AttendingUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Moms {
  int? id;
  String? description;
  int? status;
  String? createdAt;
  int? userid;
  String? username;
  String? userimage;

  Moms(
      {this.id,
      this.description,
      this.status,
      this.createdAt,
      this.userid,
      this.username,
      this.userimage});

  Moms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    userid = json['userid'];
    username = json['username'];
    userimage = json['userimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['userimage'] = this.userimage;
    return data;
  }
}
