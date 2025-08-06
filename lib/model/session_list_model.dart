class SessionListModel {
  bool? status;
  String? message;
  List<SessionListData>? data;

  SessionListModel({this.status, this.message, this.data});

  SessionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SessionListData>[];
      json['data'].forEach((v) {
        data!.add(new SessionListData.fromJson(v));
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

class SessionListData {
  int? id;
  int? documentType;
  String? fileName;
  String? fileUrl;
  String? uploadedAt;

  SessionListData(
      {this.id,
      this.documentType,
      this.fileName,
      this.fileUrl,
      this.uploadedAt});

  SessionListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentType = json['document_type'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    uploadedAt = json['uploaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_type'] = this.documentType;
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    data['uploaded_at'] = this.uploadedAt;
    return data;
  }
}
