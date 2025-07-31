import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/expense_controller.dart';
import 'package:task_management/view/screen/attendence/update_expense.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class ExpenseClaim extends StatefulWidget {
  const ExpenseClaim({super.key});

  @override
  State<ExpenseClaim> createState() => _ExpenseClaimState();
}

class _ExpenseClaimState extends State<ExpenseClaim> {
  final ExpenseController expenseController = Get.put(ExpenseController());
  @override
  initState() {
    expenseController.expenseListApi(from: "", expenseIdType: '');
    super.initState();
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          expenseClaim,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8.r),
              ),
            ),
          )
        ],
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => expenseController.isExpenseListLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: expenseController.expenseListData.isEmpty
                        ? Center(
                            child: Image.asset(
                                'assets/images/png/meeting_icons.png'),
                          )
                        : ListView.builder(
                            itemCount: expenseController.expenseListData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 5.h),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                lightGreyColor.withOpacity(0.2),
                                            blurRadius: 13.0,
                                            spreadRadius: 2,
                                            blurStyle: BlurStyle.normal,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 8.h),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                openFile(expenseController
                                                        .expenseListData[index]
                                                        .proof ??
                                                    "");
                                              },
                                              child: Container(
                                                height: 100.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.r),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.r),
                                                  ),
                                                  child: Image.network(
                                                    '${expenseController.expenseListData[index].proof}',
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Container(
                                                        height: 70.h,
                                                        width: 70.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              lightBorderColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                10.r),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Bill Number : ${expenseController.expenseListData[index].billNumber}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Text(
                                                  '${expenseController.expenseListData[index].expensetypeName}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Text(
                                                  '${expenseController.expenseListData[index].description}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Text(
                                                  '${expenseController.expenseListData[index].amount}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Text(
                                                  '${expenseController.expenseListData[index].expenseDate}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          secondaryTextColor),
                                                ),
                                                // Spacer(),
                                                // Container(
                                                //   width: 80.w,
                                                //   height: 25.h,
                                                //   decoration: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.all(
                                                //               Radius.circular(
                                                //                   12.r)),
                                                //       color: expenseController
                                                //                   .expenseListData[
                                                //                       index]
                                                //                   .status ==
                                                //               1
                                                //           ? progressBackgroundColor
                                                //           : expenseController
                                                //                       .expenseListData[
                                                //                           index]
                                                //                       .status ==
                                                //                   0
                                                //               ? softYellowColor
                                                //               : softredColor),
                                                //   child: Center(
                                                //     child: Text(
                                                //       '${expenseController.expenseListData[index].status == 1 ? "Approved" : expenseController.expenseListData[index].status == 0 ? "Pending" : "Reject"}',
                                                //       style: TextStyle(
                                                //           fontSize: 14.sp,
                                                //           color: expenseController
                                                //                       .expenseListData[
                                                //                           index]
                                                //                       .status ==
                                                //                   1
                                                //               ? greenColor
                                                //               : expenseController
                                                //                           .expenseListData[
                                                //                               index]
                                                //                           .status ==
                                                //                       0
                                                //                   ? secondaryPrimaryColor
                                                //                   : slightlyDarkColor,
                                                //           fontWeight:
                                                //               FontWeight
                                                //                   .w500),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (expenseController
                                            .expenseListData[index].status ==
                                        0)
                                      Positioned(
                                        right: 10.w,
                                        child: Container(
                                          width: 30.w,
                                          child: Center(
                                            child: PopupMenuButton(
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      Get.to(() => UpdateExpense(
                                                          expenseController
                                                                  .expenseListData[
                                                              index]));
                                                    },
                                                    child: Text(edit),
                                                  ),
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      if (expenseController
                                                              .isExpenseDeleting
                                                              .value ==
                                                          false) {
                                                        expenseController
                                                            .expenseDelete(
                                                                expenseController
                                                                        .expenseListData[
                                                                            index]
                                                                        .id ??
                                                                    0);
                                                      }
                                                    },
                                                    child: Text(delete),
                                                  ),
                                                ];
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   color: whiteColor,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 12.w, vertical: 12.h),
                  //     child: InkWell(
                  //       onTap: () {
                  //         Get.to(() => AddExpense());
                  //       },
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: blueColor,
                  //           borderRadius: BorderRadius.all(
                  //             Radius.circular(8.r),
                  //           ),
                  //         ),
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(vertical: 8.h),
                  //           child: Center(
                  //             child: Text(
                  //               'Add Expense Claim',
                  //               style: TextStyle(
                  //                 fontSize: 18,
                  //                 color: whiteColor,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
