class AllProjectListModel {
  bool? status;
  String? message;
  List<CreatedByMe>? createdByMe;
  List<CreatedByMe>? assignedToMe;

  AllProjectListModel(
      {this.status, this.message, this.createdByMe, this.assignedToMe});

  AllProjectListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['created_by_me'] != null) {
      createdByMe = <CreatedByMe>[];
      json['created_by_me'].forEach((v) {
        createdByMe!.add(new CreatedByMe.fromJson(v));
      });
    }
    if (json['assigned_to_me'] != null) {
      assignedToMe = <CreatedByMe>[];
      json['assigned_to_me'].forEach((v) {
        assignedToMe!.add(new CreatedByMe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.createdByMe != null) {
      data['created_by_me'] = this.createdByMe!.map((v) => v.toJson()).toList();
    }
    if (this.assignedToMe != null) {
      data['assigned_to_me'] =
          this.assignedToMe!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedByMe {
  int? id;
  int? userId;
  String? departmentId;
  String? name;
  int? type;
  dynamic client;
  String? responsiblePerson;
  int? teamLeader;
  String? startDate;
  String? dueDate;
  String? dueTime;
  int? priority;
  int? status;
  String? description;
  dynamic pipelineStage;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  String? statusName;
  String? responsiblePersonName;
  String? teamLeaderName;
  String? projectTypeName;
  String? clientName;
  String? departmentNames;

  CreatedByMe(
      {this.id,
      this.userId,
      this.departmentId,
      this.name,
      this.type,
      this.client,
      this.responsiblePerson,
      this.teamLeader,
      this.startDate,
      this.dueDate,
      this.dueTime,
      this.priority,
      this.status,
      this.description,
      this.pipelineStage,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.statusName,
      this.responsiblePersonName,
      this.teamLeaderName,
      this.projectTypeName,
      this.clientName,
      this.departmentNames});

  CreatedByMe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    name = json['name'];
    type = json['type'];
    client = json['client'];
    responsiblePerson = json['responsible_person'];
    teamLeader = json['team_leader'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    priority = json['priority'];
    status = json['status'];
    description = json['description'];
    pipelineStage = json['pipeline_stage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    statusName = json['status_name'];
    responsiblePersonName = json['responsible_person_name'];
    teamLeaderName = json['team_leader_name'];
    projectTypeName = json['project_type_name'];
    clientName = json['client_name'];
    departmentNames = json['department_names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['department_id'] = this.departmentId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['client'] = this.client;
    data['responsible_person'] = this.responsiblePerson;
    data['team_leader'] = this.teamLeader;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['description'] = this.description;
    data['pipeline_stage'] = this.pipelineStage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['status_name'] = this.statusName;
    data['responsible_person_name'] = this.responsiblePersonName;
    data['team_leader_name'] = this.teamLeaderName;
    data['project_type_name'] = this.projectTypeName;
    data['client_name'] = this.clientName;
    data['department_names'] = this.departmentNames;
    return data;
  }
}

// class AssignedToMe {
//   int? id;
//   int? userId;
//   String? departmentId;
//   String? name;
//   int? type;
//   dynamic client;
//   String? responsiblePerson;
//   int? teamLeader;
//   String? startDate;
//   String? dueDate;
//   String? dueTime;
//   int? priority;
//   int? status;
//   String? description;
//   dynamic pipelineStage;
//   String? createdAt;
//   String? updatedAt;
//   String? priorityName;
//   String? statusName;
//   String? responsiblePersonName;
//   String? teamLeaderName;
//   String? projectTypeName;
//   String? clientName;
//   String? departmentNames;

//   AssignedToMe(
//       {this.id,
//       this.userId,
//       this.departmentId,
//       this.name,
//       this.type,
//       this.client,
//       this.responsiblePerson,
//       this.teamLeader,
//       this.startDate,
//       this.dueDate,
//       this.dueTime,
//       this.priority,
//       this.status,
//       this.description,
//       this.pipelineStage,
//       this.createdAt,
//       this.updatedAt,
//       this.priorityName,
//       this.statusName,
//       this.responsiblePersonName,
//       this.teamLeaderName,
//       this.projectTypeName,
//       this.clientName,
//       this.departmentNames});

//   AssignedToMe.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     departmentId = json['department_id'];
//     name = json['name'];
//     type = json['type'];
//     client = json['client'];
//     responsiblePerson = json['responsible_person'];
//     teamLeader = json['team_leader'];
//     startDate = json['start_date'];
//     dueDate = json['due_date'];
//     dueTime = json['due_time'];
//     priority = json['priority'];
//     status = json['status'];
//     description = json['description'];
//     pipelineStage = json['pipeline_stage'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     priorityName = json['priority_name'];
//     statusName = json['status_name'];
//     responsiblePersonName = json['responsible_person_name'];
//     teamLeaderName = json['team_leader_name'];
//     projectTypeName = json['project_type_name'];
//     clientName = json['client_name'];
//     departmentNames = json['department_names'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['department_id'] = this.departmentId;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['client'] = this.client;
//     data['responsible_person'] = this.responsiblePerson;
//     data['team_leader'] = this.teamLeader;
//     data['start_date'] = this.startDate;
//     data['due_date'] = this.dueDate;
//     data['due_time'] = this.dueTime;
//     data['priority'] = this.priority;
//     data['status'] = this.status;
//     data['description'] = this.description;
//     data['pipeline_stage'] = this.pipelineStage;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['priority_name'] = this.priorityName;
//     data['status_name'] = this.statusName;
//     data['responsible_person_name'] = this.responsiblePersonName;
//     data['team_leader_name'] = this.teamLeaderName;
//     data['project_type_name'] = this.projectTypeName;
//     data['client_name'] = this.clientName;
//     data['department_names'] = this.departmentNames;
//     return data;
//   }
// }
