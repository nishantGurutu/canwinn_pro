class OneTimeMessageModel {
  bool? status;
  String? message;
  OneTimeMsgData? data;

  OneTimeMessageModel({this.status, this.message, this.data});

  OneTimeMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new OneTimeMsgData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OneTimeMsgData {
  int? id;
  String? message;
  dynamic time;
  int? type;
  int? status;
  String? createdAt;
  String? updatedAt;

  OneTimeMsgData(
      {this.id,
      this.message,
      this.time,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt});

  OneTimeMsgData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    time = json['time'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['time'] = this.time;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
