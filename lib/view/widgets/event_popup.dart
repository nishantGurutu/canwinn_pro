import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/calender_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class EventPopup {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();
  final CalenderController calenderController = Get.put(CalenderController());
  Future<void> eventDialog(BuildContext context,
      {required String type,
      required String firstText,
      required String secondText}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type,
                        style: rubikBlack,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const SizedBox(
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    firstText,
                    style: rubikBold,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  CustomTextField(
                    controller: nameTextController,
                    textCapitalization: TextCapitalization.none,
                    hintText: firstText,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    secondText,
                    style: rubikBold,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  secondText == "Event Date"
                      ? Column(
                          children: [
                            CustomTextField(
                              controller: dateTextController,
                              textCapitalization: TextCapitalization.none,
                              hintText: secondText,
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  onPressed: () {},
                                  text: Text(save),
                                  width: 150.w,
                                  height: 45.h,
                                  color: secondaryColor,
                                ),
                              ],
                            ),
                          ],
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: calenderController
                                    .categoryColorName.isNotEmpty
                                ? calenderController.categoryColorName
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto',
                                              // color:
                                              //     ColorConstantsLight.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList()
                                : [],
                            value: calenderController
                                .selectedCategoryColorName.value,
                            onChanged: (String? value) {
                              // blockController.selectedBlock = value;
                              // });
                              // blockController.blockDetails(blk: value?.id ?? 0);
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50.h,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 14.w, right: 14.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: borderColor,
                                ),
                                color: whiteColor,
                              ),
                            ),
                            hint: Text(
                              'Select Block',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                // color: textColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            iconStyleData: IconStyleData(
                              icon: const Icon(Icons.arrow_downward),
                              // SvgPicture.asset("assets/img/Vector (1).svg"),
                              iconSize: 14.sp,
                              iconEnabledColor: Colors.yellow,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200.h,
                              width: 330.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: whiteColor,
                              ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
