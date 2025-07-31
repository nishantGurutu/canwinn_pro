import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/view/screen/outscreen/user_chalan_details.dart';
import 'package:task_management/view/widgets/chalan_list_box.dart';

class OutChalanlist extends StatelessWidget {
  final RxList<dynamic> chalanList;
  const OutChalanlist(this.chalanList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: chalanList.isEmpty
            ? Center(
                child: Text(
                  'No chalan created',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.separated(
                itemCount: chalanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => UserChalanDetails(chalanList[index]));
                      },
                      child: ChalanListBox(
                        image: chalanList[index]['upload_image_path'] ?? "",
                        chalanNumber: chalanList[index]['challan_number'] ?? "",
                        deptName:
                            chalanList[index]['department_full_name'] ?? "",
                        dispatchTo: chalanList[index]['dispatch_to'] ?? "",
                        from: "outchalan",
                        date: chalanList[index]['date'] ?? "",
                        contact: chalanList[index]['contact'] ?? "",
                        status: chalanList[index]['status'] ?? "",
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
