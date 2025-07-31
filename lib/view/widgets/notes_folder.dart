import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:path/path.dart' as path;
import 'package:task_management/controller/document_controller.dart';
import 'package:task_management/controller/notes_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/view/screen/notes.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:share_plus/share_plus.dart';

class NotesFolder extends StatefulWidget {
  const NotesFolder({super.key});

  @override
  State<NotesFolder> createState() => _NotesFolderState();
}

class _NotesFolderState extends State<NotesFolder> {
  String currentPath = "";
  TextEditingController folderController = TextEditingController();
  final DocumentController documentController = Get.find();
  final NotesController notesController = Get.put(NotesController());

  @override
  void initState() {
    super.initState();
    notesController.listFolder();
    initializePath();
  }

  var appDocDir;

  Future<void> initializePath() async {
    appDocDir = await getApplicationDocumentsDirectory();
    setState(() {
      currentPath = appDocDir.path;
    });
  }

  Future<void> createFolder(String folderName) async {
    if (folderName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Folder name cannot be empty')),
      );
      return;
    }

    String newFolderPath = '$currentPath/$folderName';
    final directory = Directory(newFolderPath);

    if (await directory.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder "$folderName" already exists.')),
      );
    } else {
      try {
        await directory.create(recursive: true);
        notesController.addFolder(folderName);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Folder "$folderName" created.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Unable to create folder.')),
        );
      }
    }
  }

  void showFolderCreationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: folderController,
            decoration: const InputDecoration(
              labelText: 'Folder Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                folderController.clear();
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                createFolder(folderController.text.trim());
                folderController.clear();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: file),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  @override
  void dispose() {
    documentController.navigationStack.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      documentController.isLeadingVisible.value = false;
      documentController.currentPath = "/storage/emulated/0";
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (documentController.navigationStack.isNotEmpty) {
          setState(() {
            currentPath = documentController.navigationStack.removeLast();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
          ),
          title: Text(
            notesFolderText,
            style: TextStyle(
                color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Obx(() => notesController.isFolderLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (documentController.navigationStack.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (documentController
                                    .navigationStack.isNotEmpty) {
                                  setState(() {
                                    currentPath = documentController
                                        .navigationStack
                                        .removeLast();
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.arrow_back,
                                      color: Colors.black),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "${currentPath.split('/').last}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    Expanded(
                      child: Obx(() {
                        if (notesController.noteFolderList.isEmpty) {
                          return const Center(
                              child: Text('No folders or files.'));
                        }

                        return ListView.builder(
                          itemCount: notesController.noteFolderList.length,
                          itemBuilder: (context, index) {
                            final folder =
                                notesController.noteFolderList[index];
                            return InkWell(
                              onLongPress: () {
                                // Optional bottom sheet
                              },
                              child: ListTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.orange),
                                title: Text("${folder['name']}"),
                                onTap: () {
                                  Get.to(() => NotesPages(
                                        fromName: folder['name'],
                                        folderId: folder['id'],
                                        from: '',
                                      ));
                                },
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    /// Folder create button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showFolderCreationDialog();
                            },
                            child: Image.asset(
                              'assets/image/png/create_folder-removebg-preview.png',
                              height: 30.h,
                              color: const Color.fromARGB(255, 172, 156, 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }

  Widget fileBottomSheet(BuildContext context,
      {required FileSystemEntity item}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      width: double.infinity,
      height: 130.h,
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomSheetOption(
            icon: Icons.delete,
            label: "Delete",
            onTap: () => confirmDelete(context, item),
          ),
          bottomSheetOption(
            icon: Icons.share,
            label: "Share",
            onTap: () async {
              if (item is File) {
                Share.share(
                  item.path,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cannot share a folder!")));
              }
            },
          ),
          bottomSheetOption(
            icon: Icons.edit,
            label: "Rename",
            onTap: () => showRenameDialog(context, item),
          ),
        ],
      ),
    );
  }

  Widget bottomSheetOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, FileSystemEntity item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text(
            "Are you sure you want to delete '${item.path.split('/').last}'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              item.deleteSync(recursive: true);
              Navigator.pop(context);
              Get.back();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted successfully")));
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showRenameDialog(BuildContext context, FileSystemEntity item) {
    TextEditingController renameController =
        TextEditingController(text: item.path.split('/').last);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Rename"),
        content: TextField(controller: renameController),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              String newPath =
                  "${item.parent.path}/${renameController.text.trim()}";
              item.renameSync(newPath);
              Navigator.pop(context);
              Get.back();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Renamed successfully")));
            },
            child: Text("Rename"),
          ),
        ],
      ),
    );
  }

  final TextEditingController renameFileTextEditingController =
      TextEditingController();
  Widget renameFileBottomSheet(
    BuildContext context,
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
                onTap: () {},
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
      ),
    );
  }

  Widget selectOptionBottomSheet(
    BuildContext context,
    FileSystemEntity item,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 120.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Option",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (item is File) {
                          Share.shareXFiles([
                            XFile('${item.path}'),
                          ]);
                        }
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: secondaryColor,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        bool confirm = await _showDeleteConfirmation(context);
                        if (confirm) {
                          await deleteItem(item);
                          Get.back();
                        }
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteItem(FileSystemEntity item) async {
    try {
      if (item is Directory) {
        await item.delete(recursive: true);
      } else if (item is File) {
        await item.delete();
      }
      setState(() {});
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Widget floatingActionButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => bottomSheet(
            context,
          ),
        );
      },
      child: Container(
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(27.r),
          ),
          boxShadow: [
            BoxShadow(
              color: lightGreyColor.withOpacity(0.2),
              blurRadius: 13.0,
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.upload,
            color: whiteColor,
            size: 30.sp,
          ),
        ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 150.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Upload Documents",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        showFolderCreationDialog();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.folder, color: Colors.orange),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Create Folder',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        uploadFile();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.file_copy, color: Colors.blue),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              "Upload File",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? pickedFile;
  final ImagePicker picker = ImagePicker();
  String fileName = "";
  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        final String newPath = path.join(currentPath, path.basename(file.path));

        await file.copy(newPath);

        if (mounted) {
          setState(() {});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${path.basename(file.path)} uploaded successfully.')),
        );
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }
}
