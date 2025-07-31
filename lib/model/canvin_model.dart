class CanwinMemberModel {
  bool? status;
  String? message;
  List<MemberData>? data;

  CanwinMemberModel({this.status, this.message, this.data});

  CanwinMemberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MemberData>[];
      json['data'].forEach((v) {
        data!.add(new MemberData.fromJson(v));
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

class MemberData {
  int? id;
  String? name;
  String? email;
  String? role;
  String? phone;
  String? phone2;
  String? image;
  String? emailVerifiedAt;
  String? recoveryPassword;
  String? location;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? roleName;
  String? countryName;

  MemberData(
      {this.id,
      this.name,
      this.email,
      this.role,
      this.phone,
      this.phone2,
      this.image,
      this.emailVerifiedAt,
      this.recoveryPassword,
      this.location,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.roleName,
      this.countryName});

  MemberData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
    phone2 = json['phone2'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    recoveryPassword = json['recovery_password'];
    location = json['location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleName = json['role_name'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['phone2'] = this.phone2;
    data['image'] = this.image;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['recovery_password'] = this.recoveryPassword;
    data['location'] = this.location;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role_name'] = this.roleName;
    data['country_name'] = this.countryName;
    return data;
  }
}
