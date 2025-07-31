class TeamLeaderModel {
  bool? status;
  String? message;
  List<TeamLeaderData>? data;

  TeamLeaderModel({this.status, this.message, this.data});

  TeamLeaderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TeamLeaderData>[];
      json['data'].forEach((v) {
        data!.add(new TeamLeaderData.fromJson(v));
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

class TeamLeaderData {
  int? id;
  String? name;

  TeamLeaderData({this.id, this.name});

  TeamLeaderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
