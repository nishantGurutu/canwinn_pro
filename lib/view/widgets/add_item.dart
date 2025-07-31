import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';

import '../../model/product_list_model.dart';

class AddItemShet extends StatefulWidget {
  final String rate;
  const AddItemShet({super.key, required this.rate});

  @override
  State<AddItemShet> createState() => _AddItemShetState();
}

class _AddItemShetState extends State<AddItemShet> {
  final ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final LeadController leadController = Get.find();
  @override
  initState() {
    super.initState();
    leadController.selectedProductData.value = null;
    leadController.rateControlelr.text = widget.rate;
    leadController.productListApi();
  }

  @override
  void dispose() {
    super.dispose();
    leadController.qtyControlelr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Obx(
        () => leadController.isProductLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Add Item', style: heading6),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.back(); // close
                              },
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => DropdownButtonHideUnderline(
                                  child: DropdownButton2<ProductListData>(
                                    isExpanded: true,
                                    items: leadController
                                            .productListData.isEmpty
                                        ? null
                                        : leadController.productListData
                                            .map((ProductListData item) {
                                            return DropdownMenuItem<
                                                ProductListData>(
                                              value: item,
                                              child: Text(
                                                item.name ?? '',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: 'Roboto',
                                                  color: darkGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                    value: leadController
                                        .selectedProductData.value,
                                    onChanged: (ProductListData? value) {
                                      if (value != null) {
                                        leadController
                                            .selectedProductData.value = value;
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        border:
                                            Border.all(color: lightBorderColor),
                                        color: whiteColor,
                                      ),
                                    ),
                                    hint: Text(
                                      "Select Product".tr,
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
                                      maxHeight: 200.h,
                                      width: 330.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          color: whiteColor,
                                          border: Border.all(
                                              color: lightBorderColor)),
                                      offset: const Offset(0, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            WidgetStateProperty.all<double>(6),
                                        thumbVisibility:
                                            WidgetStateProperty.all<bool>(true),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TaskCustomTextField(
                                textCapitalization: TextCapitalization.none,
                                controller: leadController.qtyControlelr,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                data: "Quantity",
                                hintText: "Quantity",
                                labelText: "Quantity",
                                index: 1,
                                focusedIndexNotifier: focusedIndexNotifier,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        TaskCustomTextField(
                          controller: leadController.rateControlelr,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.number,
                          data: "Rate/Mtr/Pcs",
                          hintText: "Rate/Mtr/Pcs",
                          labelText: "Rate/Mtr/Pcs",
                          index: 2,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(height: 12.h),
                        CustomButton(
                          onPressed: () async {
                            leadController.addItemToList(
                              productId:
                                  leadController.selectedProductData.value?.id,
                              productName: leadController
                                  .selectedProductData.value?.name,
                            );
                          },
                          text: Text(
                            "Add",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          width: double.infinity,
                          color: primaryColor,
                          height: 45.h,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
