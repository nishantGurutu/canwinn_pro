import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/model/lead_details_model.dart';

class LeadAssignUserList extends StatelessWidget {
  final List<AssignedToUsers> assignUser;
  const LeadAssignUserList({super.key, required this.assignUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Text(
                  'Assigned User',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assignUser.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            height: 35.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                              color: lightGreyColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),
                              child: Image.network(
                                '${assignUser[index].image ?? ""}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            '${assignUser[index].name ?? ""}',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
