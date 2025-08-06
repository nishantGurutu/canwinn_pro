class GetLeadListModule {
  bool? status;
  dynamic message;
  List<GetListLeadMetting>? data;

  GetLeadListModule({this.status, this.message, this.data});

  GetLeadListModule.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetListLeadMetting>[];
      json['data'].forEach((v) {
        data!.add(new GetListLeadMetting.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetListLeadMetting {
  dynamic id;
  dynamic userId;
  dynamic leadId;
  dynamic meetingTitle;
  dynamic visitType;
  dynamic meetingDate;
  dynamic meetingTime;
  dynamic meetingVenue;
  dynamic attendPerson;
  dynamic meetingLink;
  dynamic startMeetingDate;
  dynamic startMeetingTime;
  dynamic endMeetingDate;
  dynamic endMeetingTime;
  dynamic outLatitude;
  dynamic outLongitude;
  dynamic latitude;
  dynamic longitude;
  dynamic meetingMom;
  dynamic selfieImage;
  dynamic reminder;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic leadsName;
  dynamic leadNumber;
  dynamic leadsPhoneNumber;
  dynamic statusText;

  GetListLeadMetting(
      {this.id,
      this.userId,
      this.leadId,
      this.meetingTitle,
      this.visitType,
      this.meetingDate,
      this.meetingTime,
      this.meetingVenue,
      this.attendPerson,
      this.meetingLink,
      this.startMeetingDate,
      this.startMeetingTime,
      this.endMeetingDate,
      this.endMeetingTime,
      this.outLatitude,
      this.outLongitude,
      this.latitude,
      this.longitude,
      this.meetingMom,
      this.selfieImage,
      this.reminder,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.leadsName,
      this.leadNumber,
      this.leadsPhoneNumber,
      this.statusText});

  GetListLeadMetting.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leadId = json['lead_id'];
    meetingTitle = json['meeting_title'];
    visitType = json['visit_type'];
    meetingDate = json['meeting_date'];
    meetingTime = json['meeting_time'];
    meetingVenue = json['meeting_venue'];
    attendPerson = json['attend_person'];
    meetingLink = json['meeting_link'];
    startMeetingDate = json['start_meeting_date'];
    startMeetingTime = json['start_meeting_time'];
    endMeetingDate = json['end_meeting_date'];
    endMeetingTime = json['end_meeting_time'];
    outLatitude = json['out_latitude'];
    outLongitude = json['out_longitude'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    meetingMom = json['meeting_mom'];
    selfieImage = json['selfie_image'];
    reminder = json['reminder'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    leadsName = json['leads_name'];
    leadNumber = json['lead_number'];
    leadsPhoneNumber = json['leads_phone_number'];
    statusText = json['status_text'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['lead_id'] = this.leadId;
    data['meeting_title'] = this.meetingTitle;
    data['visit_type'] = this.visitType;
    data['meeting_date'] = this.meetingDate;
    data['meeting_time'] = this.meetingTime;
    data['meeting_venue'] = this.meetingVenue;
    data['attend_person'] = this.attendPerson;
    data['meeting_link'] = this.meetingLink;
    data['start_meeting_date'] = this.startMeetingDate;
    data['start_meeting_time'] = this.startMeetingTime;
    data['end_meeting_date'] = this.endMeetingDate;
    data['end_meeting_time'] = this.endMeetingTime;
    data['out_latitude'] = this.outLatitude;
    data['out_longitude'] = this.outLongitude;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['meeting_mom'] = this.meetingMom;
    data['selfie_image'] = this.selfieImage;
    data['reminder'] = this.reminder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['leads_name'] = this.leadsName;
    data['lead_number'] = this.leadNumber;
    data['leads_phone_number'] = this.leadsPhoneNumber;
    data['status_text'] = this.statusText;
    return data;
  }
}
