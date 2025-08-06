import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/todo_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/notes_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/tag_list_model.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/grid_notes.dart';
import '../../constant/color_constant.dart';
import '../../constant/style_constant.dart';
import '../../constant/text_constant.dart';
import '../../controller/notes_controller.dart';
import '../../controller/priority_controller.dart';
import '../notes/notes_screens.dart';
import '../widgets/listview_notes.dart';

class NotesPages extends StatefulWidget {
  final String fromName;
  final String from;
  final int folderId;
  const NotesPages(
      {super.key,
      required this.fromName,
      required this.folderId,
      required this.from});

  @override
  State<NotesPages> createState() => _NotesPagesState();
}

class _NotesPagesState extends State<NotesPages> {
  final TodoController todoController = Get.put(TodoController());
  final NotesController notesController = Get.put(NotesController());
  final PriorityController priorityController = Get.put(PriorityController());
  @override
  void initState() {
    StorageHelper.setFolderId(widget.folderId);
    notesController.notesListApi(folderId: widget.folderId);
    super.initState();
  }

// ListViewNotes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
          widget.fromName,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 11.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: lightBorderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.r),
                ),
              ),
              height: 30.h,
              width: 25.w,
              child: PopupMenuButton<String>(
                color: whiteColor,
                constraints: BoxConstraints(
                  maxWidth: 200.w,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.r),
                ),
                shadowColor: lightGreyColor,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.more_horiz),
                onSelected: (String result) {
                  switch (result) {
                    case 'sort':
                      notesController.isGridViewVisible.value =
                          !notesController.isGridViewVisible.value;
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'sort',
                    child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text(
                        'Sort By',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: backgroundColor,
          child: Obx(
            () => notesController.isNotesLoading.value == true
                ? SizedBox(
                    height: 700.h,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : notesController.notesList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Notes data",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Click on add button to create note.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Obx(() =>
                              notesController.isGridViewVisible.value == true
                                  ? GridNotes(notesController.notesList)
                                  : ListViewNotes(notesController.notesList)),
                        ],
                      ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => todoController.isTagLoading.value == true
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  Get.to(() => NoteEditorScreen(folderId: widget.folderId));
                },
                backgroundColor: darkBlue,
                child: Icon(
                  Icons.add,
                  color: whiteColor,
                  size: 30.h,
                ),
              ),
      ),
    );
  }

  List<Color> colorList = [backgroundColor, Colors.white];

  Widget notesList(RxList<NoteData> notesList, RxList<TagData> tagList) {
    return Expanded(
      child: ListView.separated(
        itemCount: notesList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          return Container(
            color: colorList[colorIndex],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${notesList[index].title}',
                          style: changeTextColor(rubikBlack, darkGreyColor)),
                      SizedBox(
                        height: 20.h,
                        width: 30.w,
                        child: PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                editTitleTextEditingControlelr.text =
                                    notesList[index].title.toString();
                                editDescTextEditingControlelr.text =
                                    notesList[index].description.toString();
                                editTagTextEditingControlelr.text =
                                    notesList[index].tags.toString();
                                for (var td in tagList) {
                                  if (notesList[index].tags.toString() ==
                                      td.id.toString()) {
                                    todoController.selectedTagData.value = td;
                                    break;
                                  }
                                }
                                for (var pd
                                    in priorityController.priorityList) {
                                  if (priorityController.priorityList[index].id
                                          .toString() ==
                                      pd.id.toString()) {
                                    priorityController
                                        .selectedPriorityData.value = pd;
                                    break;
                                  }
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: editBottomSheet(
                                        context, notesList[index].id, tagList),
                                  ),
                                );
                                break;
                              case 'delete':
                                notesController.deleteNote(
                                  notesList[index].id,
                                );
                                break;
                              case 'view':
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: viewNotesBottomSheet(
                                        context, notesList[index]),
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: ListTile(
                                leading: Icon(Icons.view_agenda),
                                title: Text('View'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: 335.w,
                    child: Text('${notesList[index].description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: changeTextColor(rubikRegular, lightGreyColor)),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: notesList[index].tags.toString() == '1'
                              ? Colors.blue
                              : notesList[index].tags.toString() == '2'
                                  ? Colors.green
                                  : notesList[index].tags.toString() == '3'
                                      ? Colors.yellow[800]
                                      : Colors.redAccent,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '${notesList[index].tags.toString() == '1' ? "Work" : notesList[index].tags.toString() == '2' ? 'Social' : notesList[index].tags.toString() == '3' ? 'Personal' : 'Public'}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: notesList[index].tags.toString() == '1'
                                ? Colors.blue
                                : notesList[index].tags.toString() == '2'
                                    ? Colors.green
                                    : notesList[index].tags.toString() == '3'
                                        ? Colors.yellow[800]
                                        : Colors.redAccent),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (!notesController.isNotesPinnAdding.value) {
                            notesController.showPinLoadingDialog(
                                context, notesList[index].isImportant);
                            notesController.pinNote(notesList[index].id);
                          }
                        },
                        child: Container(
                          height: 30.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: thirdPrimaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.r),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/png/pin_image-removebg-preview.png',
                              height: 15.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5.h);
        },
      ),
    );
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Marking as important....',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final TextEditingController editTitleTextEditingControlelr =
      TextEditingController();
  final TextEditingController editDescTextEditingControlelr =
      TextEditingController();
  final TextEditingController editTagTextEditingControlelr =
      TextEditingController();
  final TextEditingController titleTextEditingControlelr =
      TextEditingController();
  final TextEditingController descTextEditingControlelr =
      TextEditingController();
  final TextEditingController tagTextEditingControlelr =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget editBottomSheet(
    BuildContext context,
    int? id,
    RxList<TagData> tagList,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      width: double.infinity,
      height: 400.h,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    editNotes,
                    style: rubikBlack,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: title,
                    keyboardType: TextInputType.emailAddress,
                    controller: editTitleTextEditingControlelr,
                    data: title,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: description,
                    keyboardType: TextInputType.emailAddress,
                    controller: editDescTextEditingControlelr,
                    data: description,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton2<TagData>(
                        isExpanded: true,
                        items: tagList.map((TagData item) {
                          return DropdownMenuItem<TagData>(
                            value: item,
                            child: Text(
                              item.tagName ?? "",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        value: todoController.selectedTagData.value == null
                            ? null
                            : todoController.selectedTagData.value,
                        onChanged: (TagData? value) {
                          todoController.selectedTagData.value = value;
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: lightSecondaryColor),
                            color: lightSecondaryColor,
                          ),
                        ),
                        hint: Text(
                          'Select tag',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Roboto',
                            color: darkGreyColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        iconStyleData: IconStyleData(
                          icon: Image.asset(
                            'assets/images/png/Vector 3.png',
                            color: secondaryColor,
                            height: 8.h,
                          ),
                          iconSize: 14,
                          iconEnabledColor: lightGreyColor,
                          iconDisabledColor: lightGreyColor,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 330,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: lightSecondaryColor,
                              border: Border.all(color: lightSecondaryColor)),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: WidgetStateProperty.all<double>(6),
                            thumbVisibility:
                                WidgetStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton2<PriorityData>(
                        isExpanded: true,
                        items: priorityController.priorityList
                            .map((PriorityData item) {
                          return DropdownMenuItem<PriorityData>(
                            value: item,
                            child: Text(
                              item.priorityName ?? "",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        value: priorityController.selectedPriorityData.value ==
                                null
                            ? null
                            : priorityController.selectedPriorityData.value,
                        onChanged: (PriorityData? value) {
                          priorityController.selectedPriorityData.value = value;
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: lightSecondaryColor),
                            color: lightSecondaryColor,
                          ),
                        ),
                        hint: Text(
                          'Select Priority',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Roboto',
                            color: darkGreyColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        iconStyleData: IconStyleData(
                          icon: Image.asset(
                            'assets/images/png/Vector 3.png',
                            color: secondaryColor,
                            height: 8.h,
                          ),
                          iconSize: 14,
                          iconEnabledColor: lightGreyColor,
                          iconDisabledColor: lightGreyColor,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 330,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: lightSecondaryColor,
                              border: Border.all(color: lightSecondaryColor)),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: WidgetStateProperty.all<double>(6),
                            thumbVisibility:
                                WidgetStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () => CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (notesController.isNotesEditing.value == false) {
                            notesController.editNote(
                              editTitleTextEditingControlelr.text,
                              editDescTextEditingControlelr.text,
                              todoController.selectedTagData.value?.id ?? 0,
                              priorityController.selectedPriorityData.value?.id,
                              id,
                            );
                          }
                        }
                      },
                      text: notesController.isNotesEditing.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  loading,
                                  style:
                                      changeTextColor(rubikBlack, whiteColor),
                                ),
                              ],
                            )
                          : Text(
                              submit,
                              style: TextStyle(color: whiteColor),
                            ),
                      width: double.infinity,
                      color: primaryColor,
                      height: 45.h,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Icon(
                    Icons.close,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addBottomSheet(
    BuildContext context,
    RxList<TagData> tagList,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      width: double.infinity,
      height: 400.h,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addNotes,
                    style: rubikBlack,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: title,
                    keyboardType: TextInputType.emailAddress,
                    controller: titleTextEditingControlelr,
                    data: title,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: description,
                    keyboardType: TextInputType.emailAddress,
                    controller: descTextEditingControlelr,
                    data: description,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomDropdown<TagData>(
                    items: tagList,
                    itemLabel: (item) => item.tagName ?? '',
                    onChanged: (value) {
                      todoController.selectedTagData.value = value;
                    },
                    hintText: selectTag,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomDropdown<PriorityData>(
                    items: priorityController.priorityList,
                    itemLabel: (item) => item.priorityName ?? "",
                    onChanged: (value) {
                      priorityController.selectedPriorityData.value = value;
                    },
                    hintText: selectPriority,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () => CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (notesController.isNotesAdding.value == false) {
                            // await notesController.addNote(
                            //     titleTextEditingControlelr.text,
                            //     descTextEditingControlelr.text,
                            //     // todoController.selectedTagData.value?.id ?? 0,
                            //     // priorityController.selectedPriorityData.value?.id,
                            //   );
                          }
                        }
                      },
                      text: notesController.isNotesAdding.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  loading,
                                  style:
                                      changeTextColor(rubikBlack, whiteColor),
                                ),
                              ],
                            )
                          : Text(
                              submit,
                              style: TextStyle(color: whiteColor),
                            ),
                      width: double.infinity,
                      color: primaryColor,
                      height: 45.h,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Icon(
                    Icons.close,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget viewNotesBottomSheet(
    BuildContext context,
    NoteData notesList,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      width: double.infinity,
      height: 400.h,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${notesList.title}',
                    style: changeTextColor(rubikBlack, darkGreyColor)),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: 335.w,
              child: Text('${notesList.description}',
                  style: changeTextColor(rubikRegular, lightGreyColor)),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Container(
                  height: 10.h,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: notesList.tags.toString() == '1'
                        ? Colors.blue
                        : notesList.tags.toString() == '2'
                            ? Colors.green
                            : notesList.tags.toString() == '3'
                                ? Colors.yellow[800]
                                : Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  '${notesList.tags.toString() == '1' ? "Work" : notesList.tags.toString() == '2' ? 'Social' : notesList.tags.toString() == '3' ? 'Personal' : 'Public'}',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: notesList.tags.toString() == '1'
                          ? Colors.blue
                          : notesList.tags.toString() == '2'
                              ? Colors.green
                              : notesList.tags.toString() == '3'
                                  ? Colors.yellow[800]
                                  : Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
