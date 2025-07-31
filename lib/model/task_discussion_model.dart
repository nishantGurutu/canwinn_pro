class TaskDiscussionModel {
  bool? success;
  String? message;
  List<TaskDiscussionData>? data;

  TaskDiscussionModel({this.success, this.message, this.data});

  TaskDiscussionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskDiscussionData>[];
      json['data'].forEach((v) {
        data!.add(new TaskDiscussionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskDiscussionData {
  int? id;
  int? taskId;
  int? userId;
  String? comment;
  String? attachment;
  String? createdAt;
  String? taskDate;
  String? taskTime;
  String? username;
  String? image;
  int? likesCount;
  int? dislikesCount;
  bool? liked;
  bool? disliked;
  List<SubComments>? subComments;

  TaskDiscussionData(
      {this.id,
        this.taskId,
        this.userId,
        this.comment,
        this.attachment,
        this.createdAt,
        this.taskDate,
        this.taskTime,
        this.username,
        this.image,
        this.likesCount,
        this.dislikesCount,
        this.liked,
        this.disliked,
        this.subComments});

  TaskDiscussionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    comment = json['comment'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    username = json['username'];
    image = json['image'];
    likesCount = json['likes_count'];
    dislikesCount = json['dislikes_count'];
    liked = json['liked'];
    disliked = json['disliked'];
    if (json['sub_comments'] != null) {
      subComments = <SubComments>[];
      json['sub_comments'].forEach((v) {
        subComments!.add(new SubComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['username'] = this.username;
    data['image'] = this.image;
    data['likes_count'] = this.likesCount;
    data['dislikes_count'] = this.dislikesCount;
    data['liked'] = this.liked;
    data['disliked'] = this.disliked;
    if (this.subComments != null) {
      data['sub_comments'] = this.subComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubComments {
  int? id;
  int? commentId;
  int? userId;
  String? comment;
  String? attachment;
  String? createdAt;
  String? taskDate;
  String? taskTime;
  String? username;
  String? image;
  int? likesCount;
  int? dislikesCount;
  bool? liked;
  bool? disliked;

  SubComments(
      {this.id,
        this.commentId,
        this.userId,
        this.comment,
        this.attachment,
        this.createdAt,
        this.taskDate,
        this.taskTime,
        this.username,
        this.image,
        this.likesCount,
        this.dislikesCount,
        this.liked,
        this.disliked});

  SubComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentId = json['comment_id'];
    userId = json['user_id'];
    comment = json['comment'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    username = json['username'];
    image = json['image'];
    likesCount = json['likes_count'];
    dislikesCount = json['dislikes_count'];
    liked = json['liked'];
    disliked = json['disliked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['username'] = this.username;
    data['image'] = this.image;
    data['likes_count'] = this.likesCount;
    data['dislikes_count'] = this.dislikesCount;
    data['liked'] = this.liked;
    data['disliked'] = this.disliked;
    return data;
  }
}
