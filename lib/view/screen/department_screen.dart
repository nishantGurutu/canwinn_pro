import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/view/screen/outscreen/chalanDetail.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  @override
  void initState() {
    outScreenController.outDepartmentScreenChalanApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          departmentScreen,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Obx(
          () => outScreenController.isDepartmentChalanLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : ListView.separated(
                  itemCount: outScreenController.departmentChalanList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Get.to(ChalanDetails(
                              outScreenController.departmentChalanList[index],
                              'department'));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            child: Column(
                              spacing: 8.h,
                              children: [
                                Text(
                                  'Chalan Number :- ${outScreenController.departmentChalanList[index].challanNumber ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date :- ${outScreenController.departmentChalanList[index].date ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  width: 100.w,
                                  child: Image.network(
                                    outScreenController
                                            .departmentChalanList[index]
                                            .uploadImagePath ??
                                        "",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                        ),
                                        child: Image.asset(backgroundLogo),
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  'Department Name :- ${outScreenController.departmentChalanList[index].departmentName ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Dispatch To :- ${outScreenController.departmentChalanList[index].dispatchTo ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Contact :- ${outScreenController.departmentChalanList[index].contact ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: Obx(
                                    () => DataTable2(
                                      columnSpacing: 12,
                                      horizontalMargin: 12,
                                      minWidth: 600,
                                      decoration: BoxDecoration(
                                          color: lightSecondaryColor),
                                      columns: [
                                        DataColumn2(
                                            label: Text('S. No.'),
                                            size: ColumnSize.S,
                                            fixedWidth: 50.0),
                                        DataColumn2(
                                            label: Text('Items'),
                                            size: ColumnSize.S),
                                        DataColumn2(
                                            label: Text(
                                                'RETURNABLE/NON-RETURNABLE'),
                                            size: ColumnSize.L),
                                        DataColumn2(
                                            label: Text('QTY'),
                                            size: ColumnSize.S,
                                            fixedWidth: 40.0),
                                        DataColumn2(
                                            label: Text('REMARKS'),
                                            size: ColumnSize.S,
                                            numeric: true,
                                            fixedWidth: 70.0),
                                      ],
                                      rows: List<DataRow>.generate(
                                        outScreenController
                                                .departmentChalanList[index]
                                                .items
                                                ?.length ??
                                            0,
                                        (index2) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                  '${outScreenController.departmentChalanList[index].items?[index2].id ?? ""}'),
                                            ),
                                            DataCell(
                                              Text(
                                                  '${outScreenController.departmentChalanList[index].items?[index2].itemName ?? ""}'),
                                            ),
                                            DataCell(
                                              Text(
                                                  '${outScreenController.departmentChalanList[index].items?[index2].isReturnable ?? ""}'),
                                            ),
                                            DataCell(
                                              Text(
                                                  '${outScreenController.departmentChalanList[index].items?[index2].quantity ?? ""}'),
                                            ),
                                            DataCell(
                                              Text(
                                                  '${outScreenController.departmentChalanList[index].items?[index2].remarks ?? ""}'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 90.h,
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    decoration: BoxDecoration(
                                        color: lightSecondaryColor),
                                    columns: [
                                      DataColumn2(
                                          label: Text('PREPARED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 120.0),
                                      DataColumn2(
                                          label: Text('APPROVED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 120.0),
                                      DataColumn2(
                                          label: Text('RECEIVED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 110.0),
                                      DataColumn2(
                                          label: Text('AUTHORISED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 120.0),
                                    ],
                                    rows: List<DataRow>.generate(
                                      1,
                                      (index2) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                                '${outScreenController.departmentChalanList[index].preparedBy ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.departmentChalanList[index].approvedBy ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.departmentChalanList[index].receivedBy ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.departmentChalanList[index].authorisedBy ?? ""}'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0.h,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
