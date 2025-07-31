class LeadNotesListModel {
  bool? status;
  String? message;
  List<LeadNoteData>? data;

  LeadNotesListModel({this.status, this.message, this.data});

  LeadNotesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeadNoteData>[];
      json['data'].forEach((v) {
        data!.add(new LeadNoteData.fromJson(v));
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

class LeadNoteData {
  int? id;
  int? userId;
  int? leadId;
  String? title;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Attachments>? attachments;

  LeadNoteData(
      {this.id,
      this.userId,
      this.leadId,
      this.title,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.attachments});

  LeadNoteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leadId = json['lead_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['lead_id'] = this.leadId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  int? id;
  int? leadId;
  int? noteId;
  String? attachment;
  int? status;
  String? createdAt;
  String? updatedAt;

  Attachments(
      {this.id,
      this.leadId,
      this.noteId,
      this.attachment,
      this.status,
      this.createdAt,
      this.updatedAt});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    noteId = json['note_id'];
    attachment = json['attachment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['note_id'] = this.noteId;
    data['attachment'] = this.attachment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
