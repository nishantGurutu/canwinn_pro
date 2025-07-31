// class UserCountFileModel {
//   bool? status;
//   int? totalFolders;
//   int? totalImages;
//   int? totalPdfs;
//   int? totalExcel;
//   int? totalCsv;
//   int? totalVideos;
//   int? totalAudio;
//   int? totalDocs;
//   int? totalPpt;
//   List<FoldersInfo>? foldersInfo;
//   List<FilesInfo>? filesInfo;

//   UserCountFileModel(
//       {this.status,
//       this.totalFolders,
//       this.totalImages,
//       this.totalPdfs,
//       this.totalExcel,
//       this.totalCsv,
//       this.totalVideos,
//       this.totalAudio,
//       this.totalDocs,
//       this.totalPpt,
//       this.foldersInfo,
//       this.filesInfo});

//   UserCountFileModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     totalFolders = json['total_folders'];
//     totalImages = json['total_images'];
//     totalPdfs = json['total_pdfs'];
//     totalExcel = json['total_excel'];
//     totalCsv = json['total_csv'];
//     totalVideos = json['total_videos'];
//     totalAudio = json['total_audio'];
//     totalDocs = json['total_docs'];
//     totalPpt = json['total_ppt'];
//     if (json['folders_info'] != null) {
//       foldersInfo = <FoldersInfo>[];
//       json['folders_info'].forEach((v) {
//         foldersInfo!.add(new FoldersInfo.fromJson(v));
//       });
//     }
//     if (json['files_info'] != null) {
//       filesInfo = <FilesInfo>[];
//       json['files_info'].forEach((v) {
//         filesInfo!.add(new FilesInfo.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['total_folders'] = this.totalFolders;
//     data['total_images'] = this.totalImages;
//     data['total_pdfs'] = this.totalPdfs;
//     data['total_excel'] = this.totalExcel;
//     data['total_csv'] = this.totalCsv;
//     data['total_videos'] = this.totalVideos;
//     data['total_audio'] = this.totalAudio;
//     data['total_docs'] = this.totalDocs;
//     data['total_ppt'] = this.totalPpt;
//     if (this.foldersInfo != null) {
//       data['folders_info'] = this.foldersInfo!.map((v) => v.toJson()).toList();
//     }
//     if (this.filesInfo != null) {
//       data['files_info'] = this.filesInfo!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class FoldersInfo {
//   String? folderName;
//   int? totalFiles;
//   List<Null>? sharedWith;
//   String? folderSize;

//   FoldersInfo(
//       {this.folderName, this.totalFiles, this.sharedWith, this.folderSize});

//   FoldersInfo.fromJson(Map<String, dynamic> json) {
//     folderName = json['folder_name'];
//     totalFiles = json['total_files'];
//     if (json['shared_with'] != null) {
//       sharedWith = <Null>[];
//       json['shared_with'].forEach((v) {
//         sharedWith!.add(new Null.fromJson(v));
//       });
//     }
//     folderSize = json['folder_size'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['folder_name'] = this.folderName;
//     data['total_files'] = this.totalFiles;
//     if (this.sharedWith != null) {
//       data['shared_with'] = this.sharedWith!.map((v) => v.toJson()).toList();
//     }
//     data['folder_size'] = this.folderSize;
//     return data;
//   }
// }

// class FilesInfo {
//   String? fileName;
//   String? fileSize;

//   FilesInfo({this.fileName, this.fileSize});

//   FilesInfo.fromJson(Map<String, dynamic> json) {
//     fileName = json['file_name'];
//     fileSize = json['file_size'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['file_name'] = this.fileName;
//     data['file_size'] = this.fileSize;
//     return data;
//   }
// }
