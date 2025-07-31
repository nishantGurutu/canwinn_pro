import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart'
    show backgroundLogo;
import 'package:task_management/helper/storage_helper.dart';

class FeedList extends StatelessWidget {
  final RxList feedList;
  FeedList(this.feedList, {super.key});
  List<Color> colorList = <Color>[
    feedFirstColor,
    feedSecondColor.withOpacity(0.24),
    feedThirdColor,
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: feedList.length + 1,
      itemBuilder: (context, index) {
        return index <= feedList.length - 1
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorList[index % colorList.length],
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                                child: Image.network(
                                  StorageHelper.getImage(),
                                  fit: BoxFit.cover,
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
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '${StorageHelper.getName()}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '${feedList[index]['title']}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          '${feedList[index]['description']}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColor),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          '${feedList[index]['created_at']}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 60.h,
              );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
    );
  }
}
