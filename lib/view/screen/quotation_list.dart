import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/model/quotation_list_model.dart';
import 'package:task_management/view/screen/create_quotation.dart';
import 'package:task_management/view/screen/update_quotation.dart';
import 'package:task_management/view/widgets/document_list_bottom_sheet.dart';

class QuotationListScreen extends StatefulWidget {
  final dynamic leadId;
  final String? leadNumber;
  final String from;
  final Rx<LeadDetailsData?> leadDetails;
  const QuotationListScreen(
      {super.key,
      required this.leadId,
      this.leadNumber,
      required this.from,
      required this.leadDetails});

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  final LeadController leadController = Get.put(LeadController());

  @override
  void initState() {
    super.initState();
    // print(
    //     'lead id in overview quotation ${widget.leadDetails.value!.assignedTo!}');
    Future.microtask(() {
      leadController.quotationListApi(leadId: widget.leadId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.from == "home"
          ? AppBar(
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios_new,
                    color: Colors.black, size: 20),
              ),
              title: const Text(
                "Quotation List",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: backgroundColor,
              elevation: 0,
            )
          : null,
      body: Obx(
        () {
          if (leadController.isQuotationLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (leadController.quotationListData.isEmpty) {
            return const Center(child: Text("No quotations available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: leadController.quotationListData.length,
            itemBuilder: (context, index) {
              final QuotationListData quotation =
                  leadController.quotationListData[index];

              return Card(
                color: whiteColor,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Lead: ${quotation.lead?.leadNumber ?? 'N/A'}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(() => UpdateQuotationScreen(
                                  leadId: widget.leadId,
                                  leadNumber: widget.leadNumber,
                                  quotationData:
                                      leadController.quotationListData[index]));
                            },
                            child: SvgPicture.asset(
                              'assets/image/svg/edit_icon.svg',
                              height: 20.h,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          InkWell(
                            onTap: () async {
                              if (leadController.isQuotationDownloading.value ==
                                  false) {
                                await leadController.downloadQuotation(
                                    quotation.id, quotation.quotationNumber);
                              }
                            },
                            child: Icon(
                              Icons.download,
                              size: 24.sp,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Quotation: ${quotation.quotationNumber}",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 6.h),
                      if ((widget.leadDetails.value?.assignedTo ?? "")
                          .toString()
                          .contains(StorageHelper.getId().toString()))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: DocumentListBotomsheet(
                                      from: "quotation",
                                      leadId: widget.leadId,
                                      quotationId: leadController
                                          .quotationListData[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              width: 140.w,
                              decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Not Accept",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryButtonColor,
        onPressed: () => Get.to(() => CreateQuotationScreen(
              leadId: widget.leadId,
              leadNumber: widget.leadNumber,
            )),
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null) return "-";
    try {
      final DateTime dt = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return rawDate;
    }
  }
}
