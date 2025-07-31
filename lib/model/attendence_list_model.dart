class AttendenceListModel {
  bool? status;
  Data? data;

  AttendenceListModel({this.status, this.data});

  AttendenceListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? month;
  String? year;
  int? presentDays;
  List<UserAttendenseDataList>? list;
  int? approvalPendingCount;
  int? absentCount;
  int? paidLeave;
  int? leaveCount;
  int? halfdayCount;
  String? fine;
  String? overtime;

  Data(
      {this.month,
      this.year,
      this.presentDays,
      this.list,
      this.approvalPendingCount,
      this.absentCount,
      this.paidLeave,
      this.leaveCount,
      this.halfdayCount,
      this.fine,
      this.overtime});

  Data.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    presentDays = json['present_days'];
    if (json['list'] != null) {
      list = <UserAttendenseDataList>[];
      json['list'].forEach((v) {
        list!.add(new UserAttendenseDataList.fromJson(v));
      });
    }
    approvalPendingCount = json['approval_pending_count'];
    absentCount = json['absent_count'];
    paidLeave = json['paid_leave'];
    leaveCount = json['leave_count'];
    halfdayCount = json['halfday_count'];
    fine = json['fine'];
    overtime = json['overtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    data['present_days'] = this.presentDays;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['approval_pending_count'] = this.approvalPendingCount;
    data['absent_count'] = this.absentCount;
    data['paid_leave'] = this.paidLeave;
    data['leave_count'] = this.leaveCount;
    data['halfday_count'] = this.halfdayCount;
    data['fine'] = this.fine;
    data['overtime'] = this.overtime;
    return data;
  }
}

class UserAttendenseDataList {
  dynamic id;
  dynamic userId;
  dynamic deptId;
  dynamic shiftId;
  dynamic checkIn;
  dynamic checkOut;
  dynamic checkInLatitude;
  dynamic checkInLongitude;
  dynamic checkInAddress;
  dynamic checkInImage;
  dynamic checkOutLatitude;
  dynamic checkOutLongitude;
  dynamic checkOutAddress;
  dynamic checkOutImage;
  dynamic approvedBy;
  dynamic approvedByName;
  dynamic approvedLocation;
  dynamic approvedLocationLat;
  dynamic approvedLocationLong;
  dynamic status;
  dynamic checkindate;
  dynamic checkinday;
  dynamic approvalStatus;

  UserAttendenseDataList(
      {this.id,
      this.userId,
      this.deptId,
      this.shiftId,
      this.checkIn,
      this.checkOut,
      this.checkInLatitude,
      this.checkInLongitude,
      this.checkInAddress,
      this.checkInImage,
      this.checkOutLatitude,
      this.checkOutLongitude,
      this.checkOutAddress,
      this.checkOutImage,
      this.approvedBy,
      this.approvedByName,
      this.approvedLocation,
      this.approvedLocationLat,
      this.approvedLocationLong,
      this.status,
      this.checkindate,
      this.checkinday,
      this.approvalStatus});

  UserAttendenseDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deptId = json['dept_id'];
    shiftId = json['shift_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    checkInLatitude = json['check_in_latitude'];
    checkInLongitude = json['check_in_longitude'];
    checkInAddress = json['check_in_address'];
    checkInImage = json['check_in_image'];
    checkOutLatitude = json['check_out_latitude'];
    checkOutLongitude = json['check_out_longitude'];
    checkOutAddress = json['check_out_address'];
    checkOutImage = json['check_out_image'];
    approvedBy = json['approved_by'];
    approvedByName = json['approved_by_name'];
    approvedLocation = json['approved_location'];
    approvedLocationLat = json['approved_location_lat'];
    approvedLocationLong = json['approved_location_long'];
    status = json['status'];
    checkindate = json['checkindate'];
    checkinday = json['checkinday'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dept_id'] = this.deptId;
    data['shift_id'] = this.shiftId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['check_in_latitude'] = this.checkInLatitude;
    data['check_in_longitude'] = this.checkInLongitude;
    data['check_in_address'] = this.checkInAddress;
    data['check_in_image'] = this.checkInImage;
    data['check_out_latitude'] = this.checkOutLatitude;
    data['check_out_longitude'] = this.checkOutLongitude;
    data['check_out_address'] = this.checkOutAddress;
    data['check_out_image'] = this.checkOutImage;
    data['approved_by'] = this.approvedBy;
    data['approved_by_name'] = this.approvedByName;
    data['approved_location'] = this.approvedLocation;
    data['approved_location_lat'] = this.approvedLocationLat;
    data['approved_location_long'] = this.approvedLocationLong;
    data['status'] = this.status;
    data['checkindate'] = this.checkindate;
    data['checkinday'] = this.checkinday;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}
