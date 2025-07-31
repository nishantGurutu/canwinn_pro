class ExpenseListModel {
  bool? status;
  String? message;
  List<ExpenseData>? data;

  ExpenseListModel({this.status, this.message, this.data});

  ExpenseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExpenseData>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseData.fromJson(v));
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

class ExpenseData {
  int? id;
  int? userId;
  int? expenseType;
  String? expenseDate;
  String? billNumber;
  String? amount;
  String? description;
  String? proof;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? expensetypeName;
  String? userName;

  ExpenseData(
      {this.id,
      this.userId,
      this.expenseType,
      this.expenseDate,
      this.billNumber,
      this.amount,
      this.description,
      this.proof,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.expensetypeName,
      this.userName});

  ExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    expenseType = json['expense_type'];
    expenseDate = json['expense_date'];
    billNumber = json['bill_number'];
    amount = json['amount'];
    description = json['description'];
    proof = json['proof'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expensetypeName = json['expensetype_name'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['expense_type'] = this.expenseType;
    data['expense_date'] = this.expenseDate;
    data['bill_number'] = this.billNumber;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['proof'] = this.proof;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['expensetype_name'] = this.expensetypeName;
    data['user_name'] = this.userName;
    return data;
  }
}
