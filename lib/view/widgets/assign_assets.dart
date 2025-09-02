import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';

class AssignAssetsWidget extends StatelessWidget {
  final TaskController taskController;
  final ProfileController profileController;
  final List<AssetsSubmitModel> assetsList;
  final List<bool> assetsListCheckbox;
  final String assets, qty, srNo, assigneButton;
  final Color primaryColor, lightSecondaryColor, lightGreyColor, whiteColor;

  AssignAssetsWidget({
    required this.taskController,
    required this.profileController,
    required this.assetsList,
    required this.assetsListCheckbox,
    required this.assets,
    required this.qty,
    required this.srNo,
    required this.assigneButton,
    required this.primaryColor,
    required this.lightSecondaryColor,
    required this.lightGreyColor,
    required this.whiteColor,
  });

  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController assetsSrnoTextController =
      TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  RxList<AssetsSubmitModel> selectedAssetsList = <AssetsSubmitModel>[].obs;
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            Text(
              'Assign Assets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTaskCustomTextField(assetsNameTextController, assets, 0),
                buildTaskCustomTextField(
                  quantityTextController,
                  qty,
                  1,
                  isNumeric: true,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            buildTaskCustomTextField(assetsSrnoTextController, srNo, 3),
            SizedBox(height: 15.h),
            buildSelectUserButton(context),
            SizedBox(height: 15.h),
            buildAddButton(),
            SizedBox(height: 10.h),
            buildAssetsListView(),
            buildAssignButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTaskCustomTextField(
    TextEditingController controller,
    String hint,
    int index, {
    bool isNumeric = false,
  }) {
    return SizedBox(
      width: 160.w,
      child: TaskCustomTextField(
        controller: controller,
        textCapitalization:
            isNumeric ? TextCapitalization.none : TextCapitalization.sentences,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        data: hint,
        hintText: hint,
        labelText: hint,
        index: index,
        focusedIndexNotifier: focusedIndexNotifier,
      ),
    );
  }

  Widget buildSelectUserButton(BuildContext context) {
    return InkWell(
      onTap: () {
        taskController.responsiblePersonSelectedCheckBox2.clear();
        for (var person in taskController.responsiblePersonList) {
          taskController.responsiblePersonSelectedCheckBox2[person.id] = false;
        }
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder:
              (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ResponsiblePersonList('assets', ''),
              ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: lightSecondaryColor),
          color: lightSecondaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Text('Select assign user', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget buildAddButton() {
    return CustomButton(
      color: primaryColor,
      text: Text(
        'Add',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: whiteColor,
        ),
      ),
      onPressed: () {
        int qty = int.parse(quantityTextController.text.trim());
        List<String> serialNumbers =
            assetsSrnoTextController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
        if (assetsNameTextController.text.isNotEmpty &&
            quantityTextController.text.isNotEmpty &&
            assetsSrnoTextController.text.isNotEmpty) {
          if (qty == serialNumbers.length) {
            assetsList.add(
              AssetsSubmitModel(
                name: assetsNameTextController.text.trim(),
                qty: qty,
                serialNo: serialNumbers,
              ),
            );
            assetsListCheckbox.addAll(
              List<bool>.filled(assetsList.length, false),
            );
            assetsNameTextController.clear();
            quantityTextController.clear();
            assetsSrnoTextController.clear();
          } else {
            Get.snackbar(
              "Error",
              "Add serial number according to quantity.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: primaryColor,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Please enter Asset Name, Quantity, and Serial Numbers",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            colorText: Colors.white,
          );
        }
      },
      width: 150.w,
      height: 40.h,
    );
  }

  Widget buildAssetsListView() {
    return Obx(
      () => Expanded(
        child: ListView.builder(
          itemCount: assetsList.length,
          itemBuilder: (context, index) {
            String srNumberString = assetsList[index].serialNo.join(", ");
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    boxShadow: [
                      BoxShadow(
                        color: lightGreyColor.withOpacity(0.2),
                        blurRadius: 13.0,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(srNumberString)),
                        Expanded(child: Text(assetsList[index].name ?? "")),
                        Text('${assetsList[index].qty ?? ""}'),
                        Obx(
                          () => Checkbox(
                            value: assetsListCheckbox[index],
                            onChanged: (value) {
                              assetsListCheckbox[index] = value!;
                              if (value) {
                                selectedAssetsList.add(assetsList[index]);
                              } else {
                                selectedAssetsList.remove(assetsList[index]);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildAssignButton() {
    return CustomButton(
      onPressed: () {
        if (selectedAssetsList.isNotEmpty) {
          // profileController.assignAssets(
          //     selectedAssetsList, taskController.assignedUserId);
        } else {
          CustomToast().showCustomToast("Please select assets.");
        }
      },
      text: Text(assigneButton, style: TextStyle(color: whiteColor)),
      width: double.infinity,
      color: primaryColor,
      height: 45.h,
    );
  }
}
