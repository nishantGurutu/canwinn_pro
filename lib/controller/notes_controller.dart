import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/service/noter_service.dart';
import '../model/notes_model.dart';

class NotesController {
  var isNotesLoading = false.obs;
  var isGridViewVisible = false.obs;
  var notesListModel = NotesListModel().obs;
  var notesList = [].obs;
  Future<void> notesListApi({required int folderId}) async {
    isNotesLoading.value = true;
    final result = await NotesService().notesListApi(folderId);
    if (result != null) {
      isNotesLoading.value = false;
      notesList.assignAll(result['data']);
    }
    isNotesLoading.value = false;
  }

  var profilePicPath = "".obs;
  Rx<File> pickedFile = File('').obs;
  var isNotesAdding = false.obs;
  Future<void> addNote(
      String title, String description, String colorValue, int folderId) async {
    isNotesAdding.value = true;
    final result = await NotesService()
        .addNotesApi(title, description, colorValue, pickedFile, folderId);
    if (result) {
      await notesListApi(folderId: StorageHelper.getFolderId());
      Get.back();
    } else {}
    isNotesAdding.value = false;
  }

  final HomeController homeController = Get.put(HomeController());
  var isNotesPinnAdding = false.obs;
  Future<void> pinNote(int? id) async {
    isNotesPinnAdding.value = true;
    final result = await NotesService().pinNotesApi(id);
    if (result) {
      await notesListApi(folderId: StorageHelper.getFolderId());
      await homeController.homeDataApi('');
    } else {}
    isNotesPinnAdding.value = false;
  }

  void showPinLoadingDialog(BuildContext context, int? id) {
    print('mar selected id $id');
    Get.dialog(
      AlertDialog(
        content: SizedBox(
          height: 40.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Row(
              children: [
                Center(child: CircularProgressIndicator()),
                const SizedBox(width: 20),
                Expanded(
                    child: id == 1
                        ? Text("Marking as not important...")
                        : Text("Marking as important...")),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  var isNotesEditing = false.obs;
  Future<void> editNote(String title, String description, int tag,
      int? priorityId, int? id) async {
    isNotesEditing.value = true;
    final result = await NotesService()
        .editNotesApi(title, description, tag, priorityId, id);
    if (result) {
      await notesListApi(folderId: StorageHelper.getFolderId());
      Get.back();
    } else {}
    isNotesEditing.value = false;
  }

  var isNotesDeleting = false.obs;
  Future<void> deleteNote(int? id) async {
    isNotesDeleting.value = true;
    final result = await NotesService().deleteNotes(id);
    await notesListApi(folderId: StorageHelper.getFolderId());
    isNotesDeleting.value = false;
  }

  var isDocumentAdding = false.obs;
  Future<void> addFolder(String folderName) async {
    isDocumentAdding.value = true;
    final result = await NotesService().addFolderApi(folderName);
    if (result) {
      Get.back();
      await listFolder();
    } else {}
    isDocumentAdding.value = false;
  }

  var isFolderLoading = false.obs;
  var noteFolderList = [].obs;
  Future<void> listFolder() async {
    isFolderLoading.value = true;
    final result = await NotesService().listFolderApi();
    if (result != null) {
      noteFolderList.assignAll(result['data']);
    } else {}
    isFolderLoading.value = false;
  }
}
