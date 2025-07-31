import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/document_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/user_file_count_model.dart';
import 'package:task_management/view/widgets/document_drawer.dart';
import 'package:task_management/view/screen/create_folder.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final DocumentController documentController = Get.put(DocumentController());
  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    documentController.userFileCount();
    taskController.responsiblePersonListApi(0, "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      drawer: const DocumentSideDrawer(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => _key.currentState?.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              menu_logo,
            ),
          ),
        ),
        title: Text(
          document,
          style: rubikBlack,
        ),
        actions: [
          Row(
            children: [
              SizedBox(
                  height: 40.h, width: 40.w, child: const Icon(Icons.search)),
              SizedBox(
                height: 40.h,
                width: 40.w,
                child: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: backgroundColor,
        child: Obx(
          () => documentController.isUserFileCountLoading.value == true &&
                  taskController.isResponsiblePersonLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : documentController.foldersInfoList.isEmpty
                  ? Center(
                      child: Text(
                        noFolder,
                        style: robotoRegular,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            folder,
                            style: changeTextColor(rubikBold, darkGreyColor),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        folderGrid(documentController.foldersInfoList,
                            taskController.responsiblePersonList),
                        SizedBox(
                          height: 10.h,
                        ),
                        documentController.fileInfoList.isEmpty
                            ? SizedBox()
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Text(
                                      file,
                                      style: changeTextColor(
                                          rubikBold, darkGreyColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  fileGrid(documentController.fileInfoList,
                                      taskController.responsiblePersonList),
                                ],
                              ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: primaryColor,
        animatedIcon: AnimatedIcons.close_menu,
        animatedIconTheme: IconThemeData(color: whiteColor),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.folder),
            label: createFolder,
            onTap: () async {
              final folderName = await Get.to(const CreateFolder());
              if (folderName != null && folderName is String) {
                documentController.folders.add('$folderName/');
                await documentController.addFolder(folderName);
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.upload_file),
            label: uploadFileText,
            onTap: () async {
              await uploadFile(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget folderGrid(RxList<FoldersInfo> foldersInfoList,
      RxList<ResponsiblePersonData> responsiblePersonList) {
    return Wrap(
      runSpacing: 10,
      spacing: 5,
      children: List.generate(
        foldersInfoList.length,
        (index2) {
          return Obx(
            () => GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => bottomSheet(context,
                      foldersInfoList[index2].folderId, responsiblePersonList),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Container(
                  width: 65.w,
                  child: Column(
                    children: [
                      Image.asset(
                        '$folderIcon',
                        height: 45.h,
                      ),
                      Text(
                        '${foldersInfoList[index2].folderName}',
                        style: changeTextColor(rubikRegular, darkGreyColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget fileGrid(RxList<FilesInfo> foldersInfoList,
      RxList<ResponsiblePersonData> responsiblePersonList) {
    return Wrap(
      runSpacing: 10,
      spacing: 5,
      children: List.generate(
        foldersInfoList.length,
        (index2) {
          return Obx(
            () => GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => fileBottomSheet(context,
                      foldersInfoList[index2].fileId, responsiblePersonList),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Container(
                  width: 70.w,
                  child: Column(
                    children: [
                      foldersInfoList[index2]
                              .fileName
                              .toString()
                              .contains(".pdf")
                          ? Image.asset(
                              'assets/images/png/pdf-image-removebg-preview.png',
                              height: 45.h,
                            )
                          : foldersInfoList[index2]
                                  .fileName
                                  .toString()
                                  .contains(".xlsx")
                              ? Image.asset(
                                  'assets/images/png/excel-icon.jpg',
                                  height: 45.h,
                                )
                              : Image.asset(
                                  'assets/images/png/image-file-icon.png',
                                  height: 45.h,
                                ),
                      Text(
                        '${foldersInfoList[index2].fileName}',
                        style: changeTextColor(rubikRegular, darkGreyColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  File? pickedFile;
  final ImagePicker picker = ImagePicker();
  String fileName = "";

  Future<void> uploadFile(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      pickedFile = File(pickedImage.path);
      documentController.folders.add(pickedImage.path);
      fileName = pickedFile?.path.split('/').last ?? "".toString();
      print('file name $fileName');
      await documentController.uploadFile(pickedFile);
    }
    Get.back();
  }

  Widget bottomSheet(
    BuildContext context,
    int? fileId,
    RxList<ResponsiblePersonData> responsiblePersonList,
  ) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        height: 130.h,
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                documentController.deleteFolder(fileId);
              },
              child: Text(
                delete,
                style: changeTextColor(mediumSizeText, darkGreyColor),
              ),
            ),
            SizedBox(height: 8.w),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) =>
                        shareUserList(context, responsiblePersonList, fileId));
              },
              child: Text(
                share,
                style: changeTextColor(mediumSizeText, darkGreyColor),
              ),
            ),
            SizedBox(height: 8.w),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      renameFolderBottomSheet(context, fileId),
                );
              },
              child: Text(
                rename,
                style: changeTextColor(mediumSizeText, darkGreyColor),
              ),
            ),
          ],
        ));
  }

  Widget fileBottomSheet(
    BuildContext context,
    int? fileId,
    RxList<ResponsiblePersonData> responsiblePersonList,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: double.infinity,
      height: 130.h,
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              documentController.deleteFile(fileId);
            },
            child: Text(
              delete,
              style: changeTextColor(mediumSizeText, darkGreyColor),
            ),
          ),
          SizedBox(height: 8.w),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      shareUserList(context, responsiblePersonList, fileId));
            },
            child: Text(
              share,
              style: changeTextColor(mediumSizeText, darkGreyColor),
            ),
          ),
          SizedBox(height: 8.w),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => renameFileBottomSheet(context, fileId),
              );
            },
            child: Text(
              rename,
              style: changeTextColor(mediumSizeText, darkGreyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget shareUserList(
    BuildContext context,
    RxList<ResponsiblePersonData> responsiblePersonList,
    int? fileId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: double.infinity,
      height: 170.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  documentController.shareFolder(
                      taskController.selectedResponsiblePersonId, fileId);
                },
                child: AbsorbPointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.share,
                        size: 25.h,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: responsiblePersonList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Obx(
                  () => InkWell(
                    onTap: () {
                      taskController.selectedSharedListPerson[index] =
                          !taskController.selectedSharedListPerson[index];
                      if (taskController.selectedResponsiblePersonId[index] ==
                          taskController.responsiblePersonList[index].id!) {
                        taskController.selectedResponsiblePersonId[index] = 0;
                      } else {
                        taskController.selectedResponsiblePersonId[index] =
                            taskController.responsiblePersonList[index].id!;
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.r),
                          ),
                        ),
                        width: 70.w,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                          color: lightGreyColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    '${responsiblePersonList[index].name}',
                                    style: changeTextColor(
                                        mediumSizeText, darkGreyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              taskController.selectedSharedListPerson[index] ==
                                      true
                                  ? Positioned(
                                      bottom: 1.h,
                                      right: 1.w,
                                      child: Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.r),
                                          ),
                                          color: greenColor,
                                        ),
                                        child: Icon(
                                          Icons.done,
                                          size: 15.h,
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10.w,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController renameTextEditingController =
      TextEditingController();
  Widget renameFolderBottomSheet(
    BuildContext context,
    int? fileId,
  ) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        height: 160.h,
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  renameFolder,
                  style: changeTextColor(mediumSizeText, darkGreyColor),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    documentController.renameFolder(
                        fileId, renameTextEditingController.text);
                  },
                  child: Container(
                    height: 25.h,
                    width: 30.w,
                    child: Icon(
                      Icons.done,
                      color: whiteColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.w),
            CustomTextField(
              controller: renameTextEditingController,
              data: renameFolder,
              hintText: renameFolder,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 8.w),
          ],
        ));
  }

  final TextEditingController renameFileTextEditingController =
      TextEditingController();
  Widget renameFileBottomSheet(
    BuildContext context,
    int? fileId,
  ) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        height: 160.h,
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  renameFile,
                  style: changeTextColor(mediumSizeText, darkGreyColor),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    documentController.renameFile(
                        fileId, renameFileTextEditingController.text);
                  },
                  child: Container(
                    height: 25.h,
                    width: 30.w,
                    child: Icon(Icons.done),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.w),
            CustomTextField(
              controller: renameFileTextEditingController,
              data: renameFile,
              hintText: renameFile,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 8.w),
          ],
        ));
  }
}
