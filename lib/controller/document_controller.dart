import 'dart:io';
import 'package:get/get.dart';
import 'package:task_management/model/user_file_count_model.dart';
import 'package:task_management/service/document_service.dart';

class DocumentController extends GetxController {
  RxList<String> navigationStack = <String>[].obs;
  RxBool isLeadingVisible = false.obs;
  String currentPath = "";
  RxList<String> folders = <String>[].obs;
  var isDocumentAdding = false.obs;
  Future<void> addFolder(String folderName) async {
    isDocumentAdding.value = true;
    final result = await DocumentService().addFolderApi(folderName);
    if (result) {
      await userFileCount();
    } else {}
    isDocumentAdding.value = false;
  }

  var isFileUploading = false.obs;
  Future<void> uploadFile(File? pickedFile) async {
    isFileUploading.value = true;
    final result = await DocumentService().uploadFileApi(pickedFile);
    if (result) {
      Get.back();
      await userFileCount();
    } else {}
    isFileUploading.value = false;
  }

  var isFolderUploading = false.obs;
  Future<void> uploadFolder(String folderName) async {
    isFolderUploading.value = true;
    final result = await DocumentService().uploadFolderApi(folderName);
    if (result) {
      await userFileCount();
      Get.back();
    } else {}
    isFolderUploading.value = false;
  }

  var isUserFileCountUploading = false.obs;
  Future<void> userFileCountFolder(String folderName) async {
    isUserFileCountUploading.value = true;
    final result = await DocumentService().userfileCountsApi();
    if (result) {
      Get.back();
      await userFileCount();
    } else {}
    isUserFileCountUploading.value = false;
  }

  var isFolderDeleting = false.obs;
  Future<void> deleteFolder([int? fileId]) async {
    isFolderDeleting.value = true;
    final result = await DocumentService().deleteFolder(fileId);
    if (result) {
      await userFileCount();
      Get.back();
    } else {}
    isFolderDeleting.value = false;
  }

  var isFileDeleting = false.obs;
  Future<void> deleteFile([int? fileId]) async {
    isFileDeleting.value = true;
    final result = await DocumentService().deleteFile(fileId);
    if (result) {
      await userFileCount();
      Get.back();
    } else {}
    isFileDeleting.value = false;
  }

  var isFolderRenaming = false.obs;
  Future<void> renameFolder(int? fileId, String text) async {
    isFolderRenaming.value = true;
    final result = await DocumentService().renameFolder(fileId, text);
    if (result) {
      await userFileCount();
      Get.back();
      Get.back();
    } else {}
    isFolderRenaming.value = false;
  }

  var isFileRenaming = false.obs;
  Future<void> renameFile(int? fileId, String text) async {
    isFileRenaming.value = true;
    final result = await DocumentService().renameFile(fileId, text);
    if (result) {
      await userFileCount();
      Get.back();
      Get.back();
    } else {}
    isFileRenaming.value = false;
  }

  var isFolderSharing = false.obs;
  Future<void> shareFolder(
      RxList<int> selectedResponsiblePersonId, int? fileId) async {
    isFolderSharing.value = true;
    final result = await DocumentService()
        .shareFolder(fileId, selectedResponsiblePersonId);
    if (result) {
      await userFileCount();
      Get.back();
      Get.back();
    } else {}
    isFolderSharing.value = false;
  }

  var isUserFileCountLoading = false.obs;
  var userFileCountModel = UserFileCountModel().obs;
  RxList<FoldersInfo> foldersInfoList = <FoldersInfo>[].obs;
  RxList<FilesInfo> fileInfoList = <FilesInfo>[].obs;
  RxList<dynamic> allFolderList = <dynamic>[].obs;
  Future<void> userFileCount() async {
    isUserFileCountLoading.value = true;
    final result = await DocumentService().userFileCount();
    if (result != null) {
      userFileCountModel.value = result;
      foldersInfoList.clear();
      fileInfoList.clear();
      foldersInfoList.assignAll(result.foldersInfo!);
      fileInfoList.assignAll(result.filesInfo!);
    } else {}
    isUserFileCountLoading.value = false;
  }
}
