class FollowUpsListModel {
  bool? status;
  String? message;
  List<FollowUpsListData>? data;

  FollowUpsListModel({this.status, this.message, this.data});

  FollowUpsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FollowUpsListData>[];
      json['data'].forEach((v) {
        data!.add(new FollowUpsListData.fromJson(v));
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

class FollowUpsListData {
  int? id;
  int? leadId;
  String? followUpDate;
  String? followUpTime;
  int? followUpType;
  String? note;
  String? remarks;
  dynamic reminder;
  int? status;
  String? addedBy;
  String? followuTypeName;
  String? leadsName;
  String? leadNumber;
  String? leadsPhoneNumber;
  String? statusText;

  FollowUpsListData(
      {this.id,
      this.leadId,
      this.followUpDate,
      this.followUpTime,
      this.followUpType,
      this.note,
      this.remarks,
      this.reminder,
      this.status,
      this.addedBy,
      this.followuTypeName,
      this.leadsName,
      this.leadNumber,
      this.leadsPhoneNumber,
      this.statusText});

  FollowUpsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    followUpDate = json['follow_up_date'];
    followUpTime = json['follow_up_time'];
    followUpType = json['follow_up_type'];
    note = json['note'];
    remarks = json['remarks'];
    reminder = json['reminder'];
    status = json['status'];
    addedBy = json['added_by'];
    followuTypeName = json['followu_type_name'];
    leadsName = json['leads_name'];
    leadNumber = json['lead_number'];
    leadsPhoneNumber = json['leads_phone_number'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['follow_up_date'] = this.followUpDate;
    data['follow_up_time'] = this.followUpTime;
    data['follow_up_type'] = this.followUpType;
    data['note'] = this.note;
    data['remarks'] = this.remarks;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['followu_type_name'] = this.followuTypeName;
    data['leads_name'] = this.leadsName;
    data['lead_number'] = this.leadNumber;
    data['leads_phone_number'] = this.leadsPhoneNumber;
    data['status_text'] = this.statusText;
    return data;
  }
}
