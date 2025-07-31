import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/view/screen/inscreen/inChalanDetails.dart';
import 'package:task_management/view/widgets/chalan_list_box.dart';

class InChalanlist extends StatelessWidget {
  final RxList<dynamic> inScreenChalanList;
  final OutScreenController outScreenController;
  const InChalanlist(this.inScreenChalanList, this.outScreenController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: inScreenChalanList.isEmpty
            ? Center(
                child: Text(
                  'No chalan created',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.separated(
                itemCount: outScreenController.inScreenChalanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(InChalanDetails(
                          inScreenChalanList[index]['id'].toString(),
                        ));
                      },
                      child: ChalanListBox(
                        image: inScreenChalanList[index]['upload_image'] ?? "",
                        chalanNumber:
                            inScreenChalanList[index]['challan_number'] ?? "",
                        deptName: inScreenChalanList[index]
                                ['entry_to_department'] ??
                            "",
                        dispatchTo: inScreenChalanList[index]['address'] ?? "",
                        from: "inchalan",
                        date: inScreenChalanList[index]['date'] ?? "",
                        contact: inScreenChalanList[index]['contact'] ?? "",
                        status: inScreenChalanList[index]['status'] ?? "",
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
    );
  }
}
