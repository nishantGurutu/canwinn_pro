class UploadedDocumentListModel {
  bool? status;
  String? message;
  List<UploadedDocumentData>? data;

  UploadedDocumentListModel({this.status, this.message, this.data});

  UploadedDocumentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UploadedDocumentData>[];
      json['data'].forEach((v) {
        data!.add(new UploadedDocumentData.fromJson(v));
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

class UploadedDocumentData {
  int? id;
  dynamic documentType;
  dynamic approvedBy;
  dynamic fileName;
  dynamic status;
  dynamic fileUrl;
  dynamic uploadedAt;

  UploadedDocumentData(
      {this.id,
      this.documentType,
      this.approvedBy,
      this.fileName,
      this.status,
      this.fileUrl,
      this.uploadedAt});

  UploadedDocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentType = json['document_type'];
    approvedBy = json['approved_by'];
    fileName = json['file_name'];
    status = json['status'];
    fileUrl = json['file_url'];
    uploadedAt = json['uploaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_type'] = this.documentType;
    data['approved_by'] = this.approvedBy;
    data['file_name'] = this.fileName;
    data['status'] = this.status;
    data['file_url'] = this.fileUrl;
    data['uploaded_at'] = this.uploadedAt;
    return data;
  }
}
