class AssetsListModel {
  bool? status;
  String? message;
  List<AssetsListData>? data;

  AssetsListModel({this.status, this.message, this.data});

  AssetsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AssetsListData>[];
      json['data'].forEach((v) {
        data!.add(new AssetsListData.fromJson(v));
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

class AssetsListData {
  int? id;
  String? assetName;
  String? modelName;
  String? serialNo;
  int? assetsType;
  int? assignedTo;
  String? allocationDate;
  String? releaseDate;
  String? assignedUser;
  String? assignmentStatus;

  AssetsListData(
      {this.id,
        this.assetName,
        this.modelName,
        this.serialNo,
        this.assetsType,
        this.assignedTo,
        this.allocationDate,
        this.releaseDate,
        this.assignedUser,
        this.assignmentStatus});

  AssetsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetName = json['asset_name'];
    modelName = json['model_name'];
    serialNo = json['serial_no'];
    assetsType = json['assets_type'];
    assignedTo = json['assigned_to'];
    allocationDate = json['allocation_date'];
    releaseDate = json['release_date'];
    assignedUser = json['assigned_user'];
    assignmentStatus = json['assignment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['asset_name'] = this.assetName;
    data['model_name'] = this.modelName;
    data['serial_no'] = this.serialNo;
    data['assets_type'] = this.assetsType;
    data['assigned_to'] = this.assignedTo;
    data['allocation_date'] = this.allocationDate;
    data['release_date'] = this.releaseDate;
    data['assigned_user'] = this.assignedUser;
    data['assignment_status'] = this.assignmentStatus;
    return data;
  }
}
