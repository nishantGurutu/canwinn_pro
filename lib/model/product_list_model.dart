class ProductListModel {
  bool? status;
  String? message;
  List<ProductListData>? data;

  ProductListModel({this.status, this.message, this.data});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductListData>[];
      json['data'].forEach((v) {
        data!.add(new ProductListData.fromJson(v));
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

class ProductListData {
  int? id;
  int? userId;
  String? name;
  String? purchasePrice;
  String? length;
  String? weight;
  String? diameter;
  String? rentalPrice;
  String? unit;
  String? image;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? userName;

  ProductListData(
      {this.id,
      this.userId,
      this.name,
      this.purchasePrice,
      this.length,
      this.weight,
      this.diameter,
      this.rentalPrice,
      this.unit,
      this.image,
      this.status,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.userName});

  ProductListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    purchasePrice = json['purchase_price'];
    length = json['length'].toString();
    weight = json['weight'];
    diameter = json['diameter'];
    rentalPrice = json['rental_price'];
    unit = json['unit'];
    image = json['image'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['purchase_price'] = this.purchasePrice;
    data['length'] = this.length;
    data['weight'] = this.weight;
    data['diameter'] = this.diameter;
    data['rental_price'] = this.rentalPrice;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    return data;
  }
}
