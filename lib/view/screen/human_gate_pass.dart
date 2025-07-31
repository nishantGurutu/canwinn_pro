import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:task_management/view/screen/create_human.dart';
import 'package:task_management/view/widgets/humangatepass/human_approved.dart';
import 'package:task_management/view/widgets/humangatepass/human_denied.dart';
import 'package:task_management/view/widgets/humangatepass/human_pending.dart';

class HumanGatePass extends StatefulWidget {
  final int index;
  const HumanGatePass({super.key, required this.index});

  @override
  State<HumanGatePass> createState() => _HumanGatePassState();
}

class _HumanGatePassState extends State<HumanGatePass>
    with SingleTickerProviderStateMixin {
  RxBool isPendingSelected = true.obs;
  RxBool isApprovedSelected = true.obs;
  RxBool isDeniedSelected = true.obs;
  late TabController _tabController;
  final EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  @override
  void initState() {
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index);
    employeeFormController.humanGatePassList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF000000),
            size: 20,
          ),
        ),
        title: const Text(
          "Human Gatepass",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () {
                Get.to(() => EmployeeForm());
              },
              child: Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                  color: primaryButtonColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.r),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  icon: Row(
                    children: [
                      SvgPicture.asset('assets/image/svg/assignment_late.svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Pending',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SvgPicture.asset('assets/image/svg/done_all (1).svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Approved',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SvgPicture.asset('assets/image/svg/no_accounts.svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Denied',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => employeeFormController.isGatePassloading.value == true
                    ? Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          HumanPending(),
                          HumanApproved(),
                          HumanDenied(),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
