class HomeLeadsModel {
  bool? status;
  String? message;
  HomeLeadData? data;

  HomeLeadsModel({this.status, this.message, this.data});

  HomeLeadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new HomeLeadData.fromJson(json['data']) : null;
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

class HomeLeadData {
  int? splLeads;
  int? plLeads;
  int? closedLeads;
  int? convertedLeads;
  int? newLeads;
  int? totalfollowups;
  int? totalVisits;
  int? totalLeads;
  List<PinnedNotes>? pinnedNotes;
  int? todoCount;
  int? pendingMeetings;
  int? totalmeedtings;
  int? quotationLeads;
  List<LeadsList>? leadsList;
  List<Users>? users;

  HomeLeadData(
      {this.splLeads,
      this.plLeads,
      this.closedLeads,
      this.convertedLeads,
      this.newLeads,
      this.totalfollowups,
      this.totalVisits,
      this.totalLeads,
      this.pinnedNotes,
      this.todoCount,
      this.pendingMeetings,
      this.totalmeedtings,
      this.quotationLeads,
      this.leadsList,
      this.users});

  HomeLeadData.fromJson(Map<String, dynamic> json) {
    splLeads = json['spl_leads'];
    plLeads = json['pl_leads'];
    closedLeads = json['closed_leads'];
    convertedLeads = json['converted_leads'];
    newLeads = json['new_leads'];
    totalfollowups = json['totalfollowups'];
    totalVisits = json['totalVisits'];
    totalLeads = json['total_leads'];
    if (json['pinnedNotes'] != null) {
      pinnedNotes = <PinnedNotes>[];
      json['pinnedNotes'].forEach((v) {
        pinnedNotes!.add(new PinnedNotes.fromJson(v));
      });
    }
    todoCount = json['todoCount'];
    pendingMeetings = json['pendingMeetings'];
    totalmeedtings = json['totalmeedtings'];
    quotationLeads = json['quotation_leads'];
    if (json['leadsList'] != null) {
      leadsList = <LeadsList>[];
      json['leadsList'].forEach((v) {
        leadsList!.add(new LeadsList.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spl_leads'] = this.splLeads;
    data['pl_leads'] = this.plLeads;
    data['closed_leads'] = this.closedLeads;
    data['converted_leads'] = this.convertedLeads;
    data['new_leads'] = this.newLeads;
    data['totalfollowups'] = this.totalfollowups;
    data['totalVisits'] = this.totalVisits;
    data['total_leads'] = this.totalLeads;
    if (this.pinnedNotes != null) {
      data['pinnedNotes'] = this.pinnedNotes!.map((v) => v.toJson()).toList();
    }
    data['todoCount'] = this.todoCount;
    data['pendingMeetings'] = this.pendingMeetings;
    data['totalmeedtings'] = this.totalmeedtings;
    data['quotation_leads'] = this.quotationLeads;
    if (this.leadsList != null) {
      data['leadsList'] = this.leadsList!.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PinnedNotes {
  int? id;
  int? userId;
  int? leadId;
  String? title;
  String? description;
  int? isImportant;
  int? isDeleted;
  int? status;
  String? createdAt;
  String? updatedAt;

  PinnedNotes(
      {this.id,
      this.userId,
      this.leadId,
      this.title,
      this.description,
      this.isImportant,
      this.isDeleted,
      this.status,
      this.createdAt,
      this.updatedAt});

  PinnedNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leadId = json['lead_id'];
    title = json['title'];
    description = json['description'];
    isImportant = json['is_important'];
    isDeleted = json['is_deleted'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['lead_id'] = this.leadId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_important'] = this.isImportant;
    data['is_deleted'] = this.isDeleted;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class LeadsList {
  int? id;
  String? leadNumber;
  int? userId;
  String? leadName;
  String? leadType;
  String? company;
  String? phone;
  String? email;
  int? source;
  dynamic designation;
  dynamic gender;
  int? status;
  dynamic noOfProject;
  String? description;
  dynamic regionalOfc;
  dynamic referenceDetails;
  String? image;
  dynamic type;
  dynamic addressType;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic cityTown;
  dynamic postalCode;
  dynamic sectorLocality;
  dynamic country;
  dynamic state;
  dynamic visitingCard;
  String? latitude;
  String? longitude;
  String? peopleAdded;
  String? assignedTo;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? sourceName;
  String? statusName;
  String? ownerName;

  LeadsList(
      {this.id,
      this.leadNumber,
      this.userId,
      this.leadName,
      this.leadType,
      this.company,
      this.phone,
      this.email,
      this.source,
      this.designation,
      this.gender,
      this.status,
      this.noOfProject,
      this.description,
      this.regionalOfc,
      this.referenceDetails,
      this.image,
      this.type,
      this.addressType,
      this.addressLine1,
      this.addressLine2,
      this.cityTown,
      this.postalCode,
      this.sectorLocality,
      this.country,
      this.state,
      this.visitingCard,
      this.latitude,
      this.longitude,
      this.peopleAdded,
      this.assignedTo,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.sourceName,
      this.statusName,
      this.ownerName});

  LeadsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadNumber = json['lead_number'];
    userId = json['user_id'];
    leadName = json['lead_name'];
    leadType = json['lead_type'];
    company = json['company'];
    phone = json['phone'];
    email = json['email'];
    source = json['source'];
    designation = json['designation'];
    gender = json['gender'];
    status = json['status'];
    noOfProject = json['no_of_project'];
    description = json['description'];
    regionalOfc = json['regional_ofc'];
    referenceDetails = json['reference_details'];
    image = json['image'];
    type = json['type'];
    addressType = json['address_type'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    cityTown = json['city_town'];
    postalCode = json['postal_code'];
    sectorLocality = json['sector_locality'];
    country = json['country'];
    state = json['state'];
    visitingCard = json['visiting_card'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    peopleAdded = json['people_added'];
    assignedTo = json['assigned_to'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sourceName = json['source_name'];
    statusName = json['status_name'];
    ownerName = json['owner_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_number'] = this.leadNumber;
    data['user_id'] = this.userId;
    data['lead_name'] = this.leadName;
    data['lead_type'] = this.leadType;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['source'] = this.source;
    data['designation'] = this.designation;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['no_of_project'] = this.noOfProject;
    data['description'] = this.description;
    data['regional_ofc'] = this.regionalOfc;
    data['reference_details'] = this.referenceDetails;
    data['image'] = this.image;
    data['type'] = this.type;
    data['address_type'] = this.addressType;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['city_town'] = this.cityTown;
    data['postal_code'] = this.postalCode;
    data['sector_locality'] = this.sectorLocality;
    data['country'] = this.country;
    data['state'] = this.state;
    data['visiting_card'] = this.visitingCard;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['people_added'] = this.peopleAdded;
    data['assigned_to'] = this.assignedTo;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['source_name'] = this.sourceName;
    data['status_name'] = this.statusName;
    data['owner_name'] = this.ownerName;
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? image;
  int? totalLeads;
  int? newLeads;
  int? convertedLeads;
  int? closedLeads;
  int? progressLeads;

  Users(
      {this.id,
      this.name,
      this.image,
      this.totalLeads,
      this.newLeads,
      this.convertedLeads,
      this.closedLeads,
      this.progressLeads});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    totalLeads = json['total_leads'];
    newLeads = json['new_leads'];
    convertedLeads = json['converted_leads'];
    closedLeads = json['closed_leads'];
    progressLeads = json['progress_leads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_leads'] = this.totalLeads;
    data['new_leads'] = this.newLeads;
    data['converted_leads'] = this.convertedLeads;
    data['closed_leads'] = this.closedLeads;
    data['progress_leads'] = this.progressLeads;
    return data;
  }
}
