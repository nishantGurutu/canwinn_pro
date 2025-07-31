import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/model/home_lead_model.dart';
import 'package:task_management/view/screen/lead_overview.dart';
import 'package:task_management/view/widgets/home_title.dart';

class HomeLeads extends StatelessWidget {
  final HomeLeadData? leadData;
  const HomeLeads(this.leadData, {super.key});
  String formatDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";

    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      final formatted = DateFormat("d MMM yyyy").format(dateTime);
      return formatted;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeTitle('My Leads'),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: boxBorderColor),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: lightGreyColor.withOpacity(0.1),
                  blurRadius: 13.0,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Leads Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Due Date",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Status",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: leadData?.leadsList?.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => LeadOverviewScreen(
                                    leadId: leadData?.leadsList?[index].id,
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      leadData?.leadsList?[index].leadName ??
                                          "",
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        formatDateTime(leadData
                                            ?.leadsList?[index].createdAt),
                                        style: TextStyle(fontSize: 11.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xff8C8AFE),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${leadData?.leadsList?[index].statusName ?? ''}",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: lightBorderColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
