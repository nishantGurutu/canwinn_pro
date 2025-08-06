class DocumentTypeListModel {
  bool? status;
  List<DocumentTypeListData>? data;

  DocumentTypeListModel({this.status, this.data});

  DocumentTypeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DocumentTypeListData>[];
      json['data'].forEach((v) {
        data!.add(new DocumentTypeListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentTypeListData {
  int? id;
  String? name;

  DocumentTypeListData({this.id, this.name});

  DocumentTypeListData.fromJson(Map<String, dynamic> json) {
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
