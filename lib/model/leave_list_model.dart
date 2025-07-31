class LeaveListModel {
  bool? status;
  String? message;
  List<LeaveListData>? data;

  LeaveListModel({this.status, this.message, this.data});

  LeaveListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveListData>[];
      json['data'].forEach((v) {
        data!.add(new LeaveListData.fromJson(v));
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

class LeaveListData {
  int? id;
  int? userId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? reason;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? leavetypeName;
  String? userName;
  String? leaveDateRange;

  LeaveListData(
      {this.id,
      this.userId,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.reason,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.leavetypeName,
      this.userName,
      this.leaveDateRange});

  LeaveListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    leavetypeName = json['leavetype_name'];
    userName = json['user_name'];
    leaveDateRange = json['leave_date_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['leavetype_name'] = this.leavetypeName;
    data['user_name'] = this.userName;
    data['leave_date_range'] = this.leaveDateRange;
    return data;
  }
}
