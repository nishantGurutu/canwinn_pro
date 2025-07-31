class AddTaskContactModel {
  String? name;
  String? email;
  String? mobile;

  AddTaskContactModel({
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory AddTaskContactModel.fromJson(Map<String, dynamic> json) {
    return AddTaskContactModel(
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}
