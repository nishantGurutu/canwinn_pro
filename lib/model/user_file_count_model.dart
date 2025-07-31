class UserFileCountModel {
  bool? status;
  int? totalCountFolders;
  int? totalCountImages;
  int? totalCountPdfs;
  int? totalCountExcel;
  int? totalCountCsv;
  int? totalCountVideos;
  int? totalCountAudio;
  int? totalCountDocs;
  int? totalCountPpt;
  List<FoldersInfo>? foldersInfo;
  List<FilesInfo>? filesInfo;

  UserFileCountModel(
      {this.status,
      this.totalCountFolders,
      this.totalCountImages,
      this.totalCountPdfs,
      this.totalCountExcel,
      this.totalCountCsv,
      this.totalCountVideos,
      this.totalCountAudio,
      this.totalCountDocs,
      this.totalCountPpt,
      this.foldersInfo,
      this.filesInfo});

  UserFileCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCountFolders = json['total_count_folders'];
    totalCountImages = json['total_count_images'];
    totalCountPdfs = json['total_count_pdfs'];
    totalCountExcel = json['total_count_excel'];
    totalCountCsv = json['total_count_csv'];
    totalCountVideos = json['total_count_videos'];
    totalCountAudio = json['total_count_audio'];
    totalCountDocs = json['total_count_docs'];
    totalCountPpt = json['total_count_ppt'];
    if (json['folders_info'] != null) {
      foldersInfo = <FoldersInfo>[];
      json['folders_info'].forEach((v) {
        foldersInfo!.add(new FoldersInfo.fromJson(v));
      });
    }
    if (json['files_info'] != null) {
      filesInfo = <FilesInfo>[];
      json['files_info'].forEach((v) {
        filesInfo!.add(new FilesInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_count_folders'] = this.totalCountFolders;
    data['total_count_images'] = this.totalCountImages;
    data['total_count_pdfs'] = this.totalCountPdfs;
    data['total_count_excel'] = this.totalCountExcel;
    data['total_count_csv'] = this.totalCountCsv;
    data['total_count_videos'] = this.totalCountVideos;
    data['total_count_audio'] = this.totalCountAudio;
    data['total_count_docs'] = this.totalCountDocs;
    data['total_count_ppt'] = this.totalCountPpt;
    if (this.foldersInfo != null) {
      data['folders_info'] = this.foldersInfo!.map((v) => v.toJson()).toList();
    }
    if (this.filesInfo != null) {
      data['files_info'] = this.filesInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoldersInfo {
  String? folderName;
  int? folderId;
  int? totalFiles;
  int? sharedUserCount;
  List<SharedUsersList>? sharedUsersList;
  String? folderSize;

  FoldersInfo(
      {this.folderName,
      this.folderId,
      this.totalFiles,
      this.sharedUserCount,
      this.sharedUsersList,
      this.folderSize});

  FoldersInfo.fromJson(Map<String, dynamic> json) {
    folderName = json['folder_name'];
    folderId = json['folder_id'];
    totalFiles = json['total_files'];
    sharedUserCount = json['shared_user_count'];
    if (json['shared_users_list'] != null) {
      sharedUsersList = <SharedUsersList>[];
      json['shared_users_list'].forEach((v) {
        sharedUsersList!.add(new SharedUsersList.fromJson(v));
      });
    }
    folderSize = json['folder_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folder_name'] = this.folderName;
    data['folder_id'] = this.folderId;
    data['total_files'] = this.totalFiles;
    data['shared_user_count'] = this.sharedUserCount;
    if (this.sharedUsersList != null) {
      data['shared_users_list'] =
          this.sharedUsersList!.map((v) => v.toJson()).toList();
    }
    data['folder_size'] = this.folderSize;
    return data;
  }
}

class SharedUsersList {
  int? userId;
  String? name;

  SharedUsersList({this.userId, this.name});

  SharedUsersList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    return data;
  }
}

class FilesInfo {
  String? fileName;
  int? fileId;
  String? fileSize;

  FilesInfo({this.fileName, this.fileId, this.fileSize});

  FilesInfo.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    fileId = json['file_id'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['file_id'] = this.fileId;
    data['file_size'] = this.fileSize;
    return data;
  }
}
