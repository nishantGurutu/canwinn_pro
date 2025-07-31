class BrandImagemodel {
  bool? status;
  String? message;
  List<BrandImageData>? data;

  BrandImagemodel({this.status, this.message, this.data});

  BrandImagemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BrandImageData>[];
      json['data'].forEach((v) {
        data!.add(new BrandImageData.fromJson(v));
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

class BrandImageData {
  int? id;
  int? userId;
  String? image;
  String? link;
  String? title;

  BrandImageData({this.id, this.userId, this.image, this.link, this.title});

  BrandImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    link = json['link'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['link'] = this.link;
    data['title'] = this.title;
    return data;
  }
}
