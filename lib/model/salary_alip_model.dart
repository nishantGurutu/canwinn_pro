
class SalarySlipModel {
  User? user;
  dynamic userId;
  Salary? salary;
  dynamic approval;
  dynamic presentDays;
  dynamic absentDays;
  dynamic grossEarnings;
  dynamic totalDeductions;
  dynamic netSalary;
  dynamic netPayable;
  String? month;
  String? generatedDate;

  SalarySlipModel(
      {this.user,
      this.userId,
      this.salary,
      this.approval,
      this.presentDays,
      this.absentDays,
      this.grossEarnings,
      this.totalDeductions,
      this.netSalary,
      this.netPayable,
      this.month,
      this.generatedDate});

  SalarySlipModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userId = json['user_id'];
    salary =
        json['salary'] != null ? new Salary.fromJson(json['salary']) : null;
    approval = json['approval'];
    presentDays = json['present_days'];
    absentDays = json['absent_days'];
    grossEarnings = json['gross_earnings'];
    totalDeductions = json['total_deductions'];
    netSalary = json['net_salary'];
    netPayable = json['net_payable'];
    month = json['month'];
    generatedDate = json['generated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['user_id'] = this.userId;
    if (this.salary != null) {
      data['salary'] = this.salary!.toJson();
    }
    data['approval'] = this.approval;
    data['present_days'] = this.presentDays;
    data['absent_days'] = this.absentDays;
    data['gross_earnings'] = this.grossEarnings;
    data['total_deductions'] = this.totalDeductions;
    data['net_salary'] = this.netSalary;
    data['net_payable'] = this.netPayable;
    data['month'] = this.month;
    data['generated_date'] = this.generatedDate;
    return data;
  }
}

class User {
  String? name;
  String? fatherName;
  dynamic joiningDate;
  Department? department;
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

class Salary {
  int? employeeId;
  dynamic basicSalary;
  dynamic hra;
  dynamic conveyanceAllowance;
  dynamic specialAllowance;
  dynamic lwf;
  dynamic epf;
  dynamic ctc;

  Salary(
      {this.employeeId,
      this.basicSalary,
      this.hra,
      this.conveyanceAllowance,
      this.specialAllowance,
      this.lwf,
      this.epf,
      this.ctc});

  Salary.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    basicSalary = json['basic_salary'];
    hra = json['hra'];
    conveyanceAllowance = json['conveyance_allowance'];
    specialAllowance = json['special_allowance'];
    lwf = json['lwf'];
    epf = json['epf'];
    ctc = json['ctc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['basic_salary'] = this.basicSalary;
    data['hra'] = this.hra;
    data['conveyance_allowance'] = this.conveyanceAllowance;
    data['special_allowance'] = this.specialAllowance;
    data['lwf'] = this.lwf;
    data['epf'] = this.epf;
    data['ctc'] = this.ctc;
    return data;
  }
}
