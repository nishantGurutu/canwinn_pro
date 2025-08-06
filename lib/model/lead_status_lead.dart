class LeadStatusListModel {
  bool? status;
  String? message;
  List<LeadStatusData>? data;

  LeadStatusListModel({this.status, this.message, this.data});

  LeadStatusListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = json['message'];
    }
    if (json['data'] != null) {
      data = <LeadStatusData>[];
      json['data'].forEach((v) {
        data!.add(new LeadStatusData.fromJson(v));
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

class LeadStatusData {
  dynamic id;
  dynamic name;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  LeadStatusData({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  LeadStatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadStatusData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
