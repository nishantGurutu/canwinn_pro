class UserProfileModel {
  bool? status;
  String? message;
  Data? data;

  UserProfileModel({this.status, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != dynamic) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? employeeId;
  String? name;
  String? email;
  dynamic departmentId;
  int? shiftId;
  int? checkinType;
  int? attendanceType;
  int? role;
  String? phone;
  String? phone2;
  String? image;
  String? gender;
  String? dob;
  dynamic emailVerifiedAt;
  String? recoveryPassword;
  dynamic location;
  String? fcmToken;
  int? status;
  int? type;
  String? anniversaryDate;
  String? anniversaryType;
  String? brandingImage;
  int? isLoggedIn;
  String? maritalStatus;
  String? bloodGroup;
  String? fatherName;
  String? motherName;
  String? spouseName;
  String? physicallyChallenged;
  dynamic location2;
  dynamic city;
  dynamic state;
  dynamic pincode;
  String? salaryCycle;
  dynamic reportingManager;
  String? staffType;
  String? dateOfJoining;
  dynamic uan;
  dynamic panno;
  dynamic adharno;
  dynamic adharEnrollmentno;
  dynamic pfNo;
  dynamic pfJoiningDate;
  String? pfEligible;
  String? esiEligible;
  dynamic esiNo;
  String? ptEligible;
  String? lwfEligible;
  String? epsEligible;
  dynamic epsJoiningDate;
  dynamic epsExitDate;
  String? hpsEligible;
  dynamic nameOfBank;
  dynamic ifscCode;
  dynamic accountNo;
  dynamic nameOfAccountHolder;
  dynamic upiDetails;
  String? weekoff;
  dynamic deviceId;
  int? isHead;
  String? platform;
  String? createdAt;
  String? updatedAt;
  List<AssetsData>? assets;
  List<AllocatedAssets>? allocatedAssets;

  Data(
      {this.id,
      this.employeeId,
      this.name,
      this.email,
      this.departmentId,
      this.shiftId,
      this.checkinType,
      this.attendanceType,
      this.role,
      this.phone,
      this.phone2,
      this.image,
      this.gender,
      this.dob,
      this.emailVerifiedAt,
      this.recoveryPassword,
      this.location,
      this.fcmToken,
      this.status,
      this.type,
      this.anniversaryDate,
      this.anniversaryType,
      this.brandingImage,
      this.isLoggedIn,
      this.maritalStatus,
      this.bloodGroup,
      this.fatherName,
      this.motherName,
      this.spouseName,
      this.physicallyChallenged,
      this.location2,
      this.city,
      this.state,
      this.pincode,
      this.salaryCycle,
      this.reportingManager,
      this.staffType,
      this.dateOfJoining,
      this.uan,
      this.panno,
      this.adharno,
      this.adharEnrollmentno,
      this.pfNo,
      this.pfJoiningDate,
      this.pfEligible,
      this.esiEligible,
      this.esiNo,
      this.ptEligible,
      this.lwfEligible,
      this.epsEligible,
      this.epsJoiningDate,
      this.epsExitDate,
      this.hpsEligible,
      this.nameOfBank,
      this.ifscCode,
      this.accountNo,
      this.nameOfAccountHolder,
      this.upiDetails,
      this.weekoff,
      this.deviceId,
      this.isHead,
      this.platform,
      this.createdAt,
      this.updatedAt,
      this.assets,
      this.allocatedAssets});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    email = json['email'];
    departmentId = json['department_id'];
    shiftId = json['shift_id'];
    checkinType = json['checkin_type'];
    attendanceType = json['attendance_type'];
    role = json['role'];
    phone = json['phone'];
    phone2 = json['phone2'];
    image = json['image'];
    gender = json['gender'];
    dob = json['dob'];
    emailVerifiedAt = json['email_verified_at'];
    recoveryPassword = json['recovery_password'];
    location = json['location'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    type = json['type'];
    anniversaryDate = json['anniversary_date'];
    anniversaryType = json['anniversary_type'];
    brandingImage = json['branding_image'];
    isLoggedIn = json['is_logged_in'];
    maritalStatus = json['marital_status'];
    bloodGroup = json['blood_group'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    spouseName = json['spouse_name'];
    physicallyChallenged = json['physically_challenged'];
    location2 = json['location2'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    salaryCycle = json['salary_cycle'];
    reportingManager = json['reporting_manager'];
    staffType = json['staff_type'];
    dateOfJoining = json['date_of_joining'];
    uan = json['uan'];
    panno = json['panno'];
    adharno = json['adharno'];
    adharEnrollmentno = json['adhar_enrollmentno'];
    pfNo = json['pf_no'];
    pfJoiningDate = json['pf_joining_date'];
    pfEligible = json['pf_eligible'];
    esiEligible = json['esi_eligible'];
    esiNo = json['esi_no'];
    ptEligible = json['pt_eligible'];
    lwfEligible = json['lwf_eligible'];
    epsEligible = json['eps_eligible'];
    epsJoiningDate = json['eps_joining_date'];
    epsExitDate = json['eps_exit_date'];
    hpsEligible = json['hps_eligible'];
    nameOfBank = json['name_of_bank'];
    ifscCode = json['ifsc_code'];
    accountNo = json['account_no'];
    nameOfAccountHolder = json['name_of_account_holder'];
    upiDetails = json['upi_details'];
    weekoff = json['weekoff'];
    deviceId = json['device_id'];
    isHead = json['is_head'];
    platform = json['platform'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['assets'] != dynamic) {
      assets = <AssetsData>[];
      json['assets'].forEach((v) {
        assets!.add(new AssetsData.fromJson(v));
      });
    }
    if (json['allocated_assets'] != dynamic) {
      allocatedAssets = <AllocatedAssets>[];
      json['allocated_assets'].forEach((v) {
        allocatedAssets!.add(new AllocatedAssets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department_id'] = this.departmentId;
    data['shift_id'] = this.shiftId;
    data['checkin_type'] = this.checkinType;
    data['attendance_type'] = this.attendanceType;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['phone2'] = this.phone2;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['recovery_password'] = this.recoveryPassword;
    data['location'] = this.location;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['type'] = this.type;
    data['anniversary_date'] = this.anniversaryDate;
    data['anniversary_type'] = this.anniversaryType;
    data['branding_image'] = this.brandingImage;
    data['is_logged_in'] = this.isLoggedIn;
    data['marital_status'] = this.maritalStatus;
    data['blood_group'] = this.bloodGroup;
    data['father_name'] = this.fatherName;
    data['mother_name'] = this.motherName;
    data['spouse_name'] = this.spouseName;
    data['physically_challenged'] = this.physicallyChallenged;
    data['location2'] = this.location2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['salary_cycle'] = this.salaryCycle;
    data['reporting_manager'] = this.reportingManager;
    data['staff_type'] = this.staffType;
    data['date_of_joining'] = this.dateOfJoining;
    data['uan'] = this.uan;
    data['panno'] = this.panno;
    data['adharno'] = this.adharno;
    data['adhar_enrollmentno'] = this.adharEnrollmentno;
    data['pf_no'] = this.pfNo;
    data['pf_joining_date'] = this.pfJoiningDate;
    data['pf_eligible'] = this.pfEligible;
    data['esi_eligible'] = this.esiEligible;
    data['esi_no'] = this.esiNo;
    data['pt_eligible'] = this.ptEligible;
    data['lwf_eligible'] = this.lwfEligible;
    data['eps_eligible'] = this.epsEligible;
    data['eps_joining_date'] = this.epsJoiningDate;
    data['eps_exit_date'] = this.epsExitDate;
    data['hps_eligible'] = this.hpsEligible;
    data['name_of_bank'] = this.nameOfBank;
    data['ifsc_code'] = this.ifscCode;
    data['account_no'] = this.accountNo;
    data['name_of_account_holder'] = this.nameOfAccountHolder;
    data['upi_details'] = this.upiDetails;
    data['weekoff'] = this.weekoff;
    data['device_id'] = this.deviceId;
    data['is_head'] = this.isHead;
    data['platform'] = this.platform;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.assets != dynamic) {
      data['assets'] = this.assets!.map((v) => v.toJson()).toList();
    }
    if (this.allocatedAssets != dynamic) {
      data['allocated_assets'] =
          this.allocatedAssets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssetsData {
  int? id;
  int? userId;
  String? assignedTo;
  String? name;
  int? qty;
  String? serialNo;
  int? status;
  String? createdAt;
  String? updatedAt;

  AssetsData(
      {this.id,
      this.userId,
      this.assignedTo,
      this.name,
      this.qty,
      this.serialNo,
      this.status,
      this.createdAt,
      this.updatedAt});

  AssetsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    assignedTo = json['assigned_to'];
    name = json['name'];
    qty = json['qty'];
    serialNo = json['serial_no'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['assigned_to'] = this.assignedTo;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['serial_no'] = this.serialNo;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AllocatedAssets {
  int? id;
  int? userId;
  int? assignedTo;
  int? assetId;
  String? allocationDate;
  String? releaseDate;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? assetName;
  String? assetModelName;
  String? assetSerialNo;
  String? assignedUser;

  AllocatedAssets(
      {this.id,
      this.userId,
      this.assignedTo,
      this.assetId,
      this.allocationDate,
      this.releaseDate,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.assetName,
      this.assetModelName,
      this.assetSerialNo,
      this.assignedUser});

  AllocatedAssets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    assignedTo = json['assigned_to'];
    assetId = json['asset_id'];
    allocationDate = json['allocation_date'];
    releaseDate = json['release_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    assetName = json['asset_name'];
    assetModelName = json['asset_model_name'];
    assetSerialNo = json['asset_serial_no'];
    assignedUser = json['assigned_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['assigned_to'] = this.assignedTo;
    data['asset_id'] = this.assetId;
    data['allocation_date'] = this.allocationDate;
    data['release_date'] = this.releaseDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['asset_name'] = this.assetName;
    data['asset_model_name'] = this.assetModelName;
    data['asset_serial_no'] = this.assetSerialNo;
    data['assigned_user'] = this.assignedUser;
    return data;
  }
}
