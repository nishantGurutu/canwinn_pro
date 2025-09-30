class SalaryOverviewModel {
  User? user;
  int? userId;
  List<Salaries>? salaries;

  SalaryOverviewModel({this.user, this.userId, this.salaries});

  SalaryOverviewModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userId = json['user_id'];
    if (json['salaries'] != null) {
      salaries = <Salaries>[];
      json['salaries'].forEach((v) {
        salaries!.add(new Salaries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['user_id'] = this.userId;
    if (this.salaries != null) {
      data['salaries'] = this.salaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? name;
  dynamic fatherName;
  dynamic joiningDate;
  dynamic department;
  dynamic role;

  User(
      {this.name,
      this.fatherName,
      this.joiningDate,
      this.department,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fatherName = json['father_name'];
    joiningDate = json['joining_date'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['father_name'] = this.fatherName;
    data['joining_date'] = this.joiningDate;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    data['role'] = this.role;
    return data;
  }
}

class Department {
  int? id;
  dynamic companyId;
  dynamic name;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  Department(
      {this.id,
      this.companyId,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Salaries {
  int? employeeId;
  dynamic salaryIssueDate;
  dynamic approvalId;
  dynamic isApproved;
  dynamic salaryStatus;
  dynamic payDays;
  dynamic absentDays;
  dynamic halfDays;

  Salaries(
      {this.employeeId,
      this.salaryIssueDate,
      this.approvalId,
      this.isApproved,
      this.salaryStatus,
      this.payDays,
      this.absentDays,
      this.halfDays});

  Salaries.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    salaryIssueDate = json['salary_issue_date'];
    approvalId = json['approval_id'];
    isApproved = json['is_approved'];
    salaryStatus = json['salary_status'];
    payDays = json['pay_days'];
    absentDays = json['absent_days'];
    halfDays = json['half_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['salary_issue_date'] = this.salaryIssueDate;
    data['approval_id'] = this.approvalId;
    data['is_approved'] = this.isApproved;
    data['salary_status'] = this.salaryStatus;
    data['pay_days'] = this.payDays;
    data['absent_days'] = this.absentDays;
    data['half_days'] = this.halfDays;
    return data;
  }
}
