class RegisterModel {
  bool? status;
  String? message;
  RegisterData? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
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

class RegisterData {
  int? id;
  String? name;
  String? email;
  String? recoveryPassword;
  String? token;
  String? tokenType;

  RegisterData(
      {this.id,
      this.name,
      this.email,
      this.recoveryPassword,
      this.token,
      this.tokenType});

  RegisterData.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
    email = json['email'].toString();
    recoveryPassword = json['recovery_password'].toString();
    token = json['token'].toString();
    tokenType = json['token_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['recovery_password'] = this.recoveryPassword;
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    return data;
  }
}
