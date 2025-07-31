import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:task_management/constant/color_constant.dart'
    show
        backgroundColor,
        borderColor,
        darkGreyColor,
        lightBorderColor,
        primaryColor,
        whiteColor;
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/controller/meeting_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/lead_contact_list_model.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/viewmodel/followups_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'meeting_form.dart';

class GetMeetingList extends StatefulWidget {
  final dynamic leadId;
  final RxList<LeadContactData> contactList;
  final dynamic from;
  final List<AssignedToUsers> assignPeople;
  final List<AssignedToUsers> addPeople;
  const GetMeetingList({
    super.key,
    required this.leadId,
    required this.contactList,
    required this.from,
    required this.assignPeople,
    required this.addPeople,
  });

  @override
  State<GetMeetingList> createState() => _GetMeetingListState();
}

class _GetMeetingListState extends State<GetMeetingList> {
  final MeetingController meetingController = Get.put(MeetingController());
  final LeadController leadController = Get.put(LeadController());
  RxString time = "00:00:00.000".obs;
  late DateTime startTime;
  Timer? timer;

  List<AssignedToUsers> mergedPeopleList = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      apiCall();
    });

    if (widget.contactList.isNotEmpty ||
        widget.assignPeople.isNotEmpty ||
        widget.addPeople.isNotEmpty) {
      startTime = DateTime.now();
      List<AssignedToUsers> contactList = widget.contactList.map((contact) {
        return AssignedToUsers(
          id: int.parse(contact.id.toString()),
          name: contact.name.toString(),
          image: '',
        );
      }).toList();

      List<AssignedToUsers> assignList = widget.assignPeople ?? [];
      List<AssignedToUsers> addList = widget.addPeople ?? [];

      mergedPeopleList = [...contactList, ...assignList, ...addList];

      final ids = <int?>{};
      mergedPeopleList = mergedPeopleList.where((person) {
        if (ids.contains(person.id)) {
          return false;
        } else {
          ids.add(person.id);
          return true;
        }
      }).toList();
    }

    print('meeting list in lead ye8738 ${widget.leadId}');
  }

  var isLoading = false;
  Future<void> apiCall() async {
    isLoading = true;
    await leadController.fetchLeadMeetings(leadId: widget.leadId);
    await meetingController.responsiblePersonListApi('', "");
    isLoading = false;
  }

  static const countdownDuration = Duration(minutes: 1);
  Duration _duration = countdownDuration;
  Timer? _timer;
  bool _isTimerRunning = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = Duration(seconds: _duration.inSeconds - 1);
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
        }
      });
    });
    _isTimerRunning = true;
  }

  void stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  void resetTimer() {
    setState(() {
      _duration = countdownDuration;
      _timer?.cancel();
      _isTimerRunning = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> capturePhotoAndLocation(String type) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        Get.snackbar("Cancelled", "No image captured");
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      debugPrint('[$type] Image Path: ${pickedFile.path}');
      debugPrint(
          '[$type] Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      Get.snackbar("$type Captured",
          "Lat: ${position.latitude}, Lng: ${position.longitude}");
    } catch (e) {
      debugPrint("Error: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  String getSelectedStatus(int? status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Completed";
      case 2:
        return "Reschedule";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.from == 'home'
          ? AppBar(
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
                "Visit/Meeting List",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: backgroundColor,
              elevation: 0,
            )
          : null,
      body: Obx(() {
        if (leadController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leadController.meetingList.isEmpty) {
          return const Center(child: Text('No meetings found.'));
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: leadController.meetingList.length,
                    itemBuilder: (context, index) {
                      final item = leadController.meetingList[index];
                      String formattedCreatedDate = '';
                      if (item.createdAt != null) {
                        DateTime created = DateTime.tryParse(item.createdAt!) ??
                            DateTime.now();
                        formattedCreatedDate =
                            DateFormat('dd MMM yyyy, hh:mm a').format(created);
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: lightBorderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text("Lead : ${item.leadsName ?? ''}",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("${item.leadNumber ?? ''}",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.title,
                                    size: 18.sp, color: Colors.blue),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.meetingTitle ?? 'No Title',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    size: 18.sp, color: Colors.deepPurple),
                                SizedBox(width: 6.w),
                                Text(
                                    '${item.meetingDate ?? ''} at ${item.meetingTime ?? ''}',
                                    style: TextStyle(fontSize: 13.sp)),
                                Spacer(),
                                if (item.status.toString() == "3")
                                  Text("Meeting Resheduled",
                                      style: TextStyle(color: Colors.black)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (item.startMeetingTime != null &&
                                        item.startMeetingTime != "null") ...[
                                      Text("Meeting Start",
                                          style:
                                              TextStyle(color: Colors.green)),
                                      Text(
                                        item.startMeetingTime!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.red, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                    child: Text(item.meetingVenue ?? '',
                                        style: TextStyle(fontSize: 13.sp))),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (item.endMeetingTime != null &&
                                        item.endMeetingTime != "null") ...[
                                      Text("Meeting End",
                                          style:
                                              TextStyle(color: Colors.green)),
                                      Text(
                                        item.endMeetingTime!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.group,
                                    color: Colors.green, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                    child: Text(item.attendPerson ?? '',
                                        style: TextStyle(fontSize: 13.sp))),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.note,
                                    color: Colors.teal, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                    child: Text(
                                        item.meetingMom ?? 'No MOM updated',
                                        style: TextStyle(fontSize: 13.sp))),
                                const Spacer(),
                                if (item.leadsPhoneNumber != null) ...[
                                  GestureDetector(
                                    onTap: () => callWhatsApp(
                                        mobileNo: item.leadsPhoneNumber),
                                    child: Image.asset(
                                      'assets/image/png/whatsapp (2).png',
                                      height: 25.h,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () async {
                                      final phoneno = Uri.parse(
                                          'tel:${item.leadsPhoneNumber}');
                                      if (!await launchUrl(phoneno)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Failed to make call')),
                                        );
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/image/png/phone_call-removebg-preview.png',
                                      height: 25.h,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18.sp, color: Colors.orange),
                                SizedBox(width: 6.w),
                                Text('Created: $formattedCreatedDate',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic)),
                                Spacer(),
                                SizedBox(
                                  height: 30.h,
                                  width: 100.w,
                                  child: Obx(() {
                                    final status = item.status.toString();
                                    final disabled =
                                        status == "2" || status == "3";

                                    final uniqueStatuses = leadController
                                        .visitStatustype
                                        .toSet()
                                        .toList();

                                    final current = (leadController
                                                .selectedStatusTypeList.length >
                                            index)
                                        ? leadController
                                            .selectedStatusTypeList[index]
                                        : '';

                                    final safeValue =
                                        uniqueStatuses.contains(current)
                                            ? current
                                            : null;

                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        items: uniqueStatuses.map((s) {
                                          return DropdownMenuItem<String>(
                                            value: s,
                                            child: Text(s,
                                                style: TextStyle(
                                                    color: darkGreyColor)),
                                          );
                                        }).toList(),
                                        value: safeValue,
                                        hint: Text(
                                          'Status',
                                          style: TextStyle(
                                              color: disabled
                                                  ? Colors.grey
                                                  : darkGreyColor),
                                        ),
                                        onChanged: disabled
                                            ? null
                                            : (value) async {
                                                if (value != null) {
                                                  leadController
                                                          .selectedStatusTypeList[
                                                      index] = value;
                                                  leadController.pickedFile
                                                      .value = File("");
                                                  leadController
                                                      .pickedImage.value = '';
                                                  await showAlertDialog(
                                                      context,
                                                      leadController
                                                          .meetingList[index]
                                                          .id,
                                                      leadId: item.leadId,
                                                      selectedValue: leadController
                                                              .selectedStatusTypeList[
                                                          index]);
                                                }
                                              },
                                        buttonStyleData: ButtonStyleData(
                                          height: 45.h,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            border: Border.all(
                                                color: lightBorderColor),
                                            color: disabled
                                                ? Colors.grey[300]
                                                : whiteColor,
                                          ),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: Image.asset(
                                            'assets/images/png/Vector 3.png',
                                            color: disabled
                                                ? Colors.grey
                                                : borderColor,
                                            height: 5.h,
                                          ),
                                          iconSize: 14,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          width: 100.w,
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                          padding: EdgeInsets.only(
                                              left: 14, right: 14),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: widget.from == 'home'
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => MeetingScreens(
                    leadId: widget.leadId,
                    mergedPeopleList: mergedPeopleList,
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Future<void> callWhatsApp({String? mobileNo}) async {
    String? mobileContact =
        mobileNo!.contains('+91') ? mobileNo : "+91$mobileNo";
    var androidUrl = "whatsapp://send?phone=$mobileContact";
    var iosUrl = "https://wa.me/$mobileContact";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  ValueNotifier<int?> meetingControllerNotifier = ValueNotifier<int?>(null);

  final TextEditingController meetingTitleController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      leadController.isImageLoading.value = true;
      leadController.pickedFile.value = File(pickedImage.path);
      leadController.pickedImage.value = pickedImage.path.toString();
      leadController.isImageLoading.value = false;
      // Get.back();
    } catch (e) {
      leadController.isImageLoading.value = false;
    } finally {
      leadController.isImageLoading.value = false;
    }
  }

  final followupsVM = Get.put(FollowupsViewModel());
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> showAlertDialog(BuildContext context, int? id,
      {required leadId, required String selectedValue}) async {
    print('kajshiu eij 87y87');
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      if (selectedValue == "Start")
                        SizedBox(
                          height: 15.h,
                        ),
                      if (selectedValue == "Start")
                        Obx(
                          () => DottedBorder(
                            color: Colors.grey,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12.r),
                            dashPattern: [6, 4],
                            strokeWidth: 1.5,
                            child: InkWell(
                              onTap: () => takePhoto(ImageSource.camera),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                height: 100.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: leadController.isImageLoading.value
                                    ? CircularProgressIndicator()
                                    : (leadController.pickedImage.value.isEmpty
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.camera_alt_outlined,
                                                  size: 28.sp,
                                                  color: Colors.grey),
                                              SizedBox(height: 8.h),
                                              Text(
                                                "Upload live image",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            child: Image.file(
                                              leadController.pickedFile.value,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          )),
                              ),
                            ),
                          ),
                        ),
                      if (selectedValue == "Done" ||
                          selectedValue == "Reshedule")
                        SizedBox(
                          height: 10.h,
                        ),
                      if (selectedValue == "Done" ||
                          selectedValue == "Reshedule")
                        TaskCustomTextField(
                          controller: meetingTitleController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'Remark',
                          hintText: 'Remark',
                          labelText: 'Remark',
                          maxLine: 3,
                          index: 1,
                          focusedIndexNotifier: meetingControllerNotifier,
                        ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: () {
                      if (leadController.isLeadVisitStatusChanging.value ==
                          false) {
                        leadController.changeVisitStatus(
                          image: leadController.pickedFile.value,
                          latitude: "7632873",
                          longitude: '876876',
                          id: id,
                          status: selectedValue == "Start"
                              ? 1
                              : selectedValue == "Done"
                                  ? 2
                                  : 3,
                          remark: meetingTitleController.text,
                          leadid: leadId,
                          selectedValue: selectedValue,
                          mergedPeopleList: mergedPeopleList,
                        );
                      }
                    },
                    text: Text(
                      selectedValue == "Done"
                          ? "End Visit/Meeting"
                          : selectedValue == "Reshedule"
                              ? "Reshedule Visit/Meeting"
                              : "Start Visit/Meeting",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    width: double.infinity,
                    color: primaryColor,
                    height: 45.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
