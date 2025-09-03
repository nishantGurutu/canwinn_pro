import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/new_group_second.dart';
import '../../constant/text_constant.dart';

class NewGroup extends StatefulWidget {
  final RxList<ResponsiblePersonData> responsiblePersonList;
  const NewGroup(this.responsiblePersonList, {super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final RxList<ResponsiblePersonData> selectedList =
      <ResponsiblePersonData>[].obs;
  final RxList<ResponsiblePersonData> filteredList =
      <ResponsiblePersonData>[].obs;
  final TextEditingController searchAssignController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList.value = widget.responsiblePersonList;
    ever(widget.responsiblePersonList, (_) {
      _updateFilteredList();
    });
    searchAssignController.addListener(() {
      _updateFilteredList();
    });
    selectedList.clear();
  }

  void _updateFilteredList() {
    final searchText = searchAssignController.text.toLowerCase();
    filteredList.value =
        widget.responsiblePersonList
            .where(
              (person) =>
                  person.name?.toLowerCase().contains(searchText) ?? false,
            )
            .toList();
  }

  @override
  void dispose() {
    searchAssignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          newGroup,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: TextFormField(
                  controller: searchAssignController,
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    fillColor: searchBackgroundColor,
                    filled: true,
                    labelStyle: TextStyle(color: searchBackgroundColor),
                    counterText: "",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Expanded(
                child:
                    filteredList.isEmpty
                        ? Center(
                          child: Text(
                            'No contacts found',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        )
                        : ListView.separated(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (selectedList.contains(
                                  filteredList[index],
                                )) {
                                  selectedList.remove(filteredList[index]);
                                } else {
                                  selectedList.add(filteredList[index]);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  top: 10.h,
                                  right: 15.w,
                                ),
                                child: Row(
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(22.5),
                                        ),
                                        child: Image.network(
                                          filteredList[index].image ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.r),
                                                ),
                                              ),
                                              child: Image.asset(
                                                backgroundLogo,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 7.w),
                                    Expanded(
                                      child: Text(
                                        "${filteredList[index].name}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacer(),
                                    Obx(
                                      () =>
                                          selectedList.contains(
                                                filteredList[index],
                                              )
                                              ? SvgPicture.asset(
                                                'assets/images/svg/done.svg',
                                                height: 16.h,
                                              )
                                              : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 8.h);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          if (selectedList.isNotEmpty) {
            Get.to(NewGroupSecond(selectedList));
          } else {
            CustomToast().showCustomToast('Please select at least one person.');
          }
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.arrow_right_alt, color: whiteColor),
      ),
    );
  }
}
