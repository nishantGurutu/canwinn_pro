import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/model/task_details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskContactList extends StatelessWidget {
  final RxList<ContactsData> addTaskContactList;
  const TaskContactList(this.addTaskContactList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          'Contact List',
          style: heading15,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addTaskContactList.length,
                itemBuilder: (context, index) {
                  final contact = addTaskContactList[index];
                  final firstChar =
                      contact.name!.isNotEmpty ? contact.name![0] : '?';
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundGreyColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 7.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 44.h,
                                  width: 44.w,
                                  decoration: BoxDecoration(
                                    color: lightGreyColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(22.r),
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
                                  child: Center(
                                    child: Text(
                                      firstChar,
                                      style:
                                          changeTextColor(heading9, whiteColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  width: 240.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${addTaskContactList[index].name ?? ""}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: heading19,
                                      ),
                                      Text(
                                        '${addTaskContactList[index].email ?? ""}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: heading17,
                                      ),
                                      Text(
                                        '${addTaskContactList[index].mobile ?? ""}',
                                        style: heading17,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final phoneNumber =
                                                  addTaskContactList[index]
                                                      .mobile;
                                              final Uri uri = Uri(
                                                  scheme: 'tel',
                                                  path: phoneNumber);

                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Could not launch dialer')),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 24.h,
                                              width: 24.w,
                                              child: Icon(
                                                Icons.call,
                                                color: chatColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final phoneNumber =
                                                  addTaskContactList[index]
                                                      .mobile;
                                              callWhatsApp(phoneNumber);
                                            },
                                            icon: Image.asset(
                                              'assets/image/png/whatsapp-removebg-preview.png',
                                              height: 23.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              _launchEmail(
                                                context,
                                                addTaskContactList[index]
                                                    .mobile,
                                              );
                                            },
                                            child: Container(
                                              height: 24.h,
                                              width: 24.w,
                                              child: Icon(
                                                Icons.email,
                                                color: buttonRedColor,
                                                size: 24.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, String? mobile) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'nishantkr405@gmail.com',
      queryParameters: {
        'subject': 'ueyue',
        'body': 'jeyy',
      },
    );
    final Uri webFallback = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1&to=nishantkr405@gmail.com&su=ueyue&body=jeyy');

    try {
      print('Attempting to launch: $emailUri');
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        print('No email client found, trying web fallback');
        if (await canLaunchUrl(webFallback)) {
          await launchUrl(webFallback);
        } else {
          await Clipboard.setData(
              const ClipboardData(text: 'nishantkr405@gmail.com'));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('No email client found. Email copied to clipboard.')),
          );
        }
      }
    } catch (e) {
      print('Error launching email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching email: $e')),
      );
    }
  }

  // Future<void> _launchEmail() async {
  //   final url = Uri.parse(
  //       'mailto:nishantkr405@gmail.com?subject=${Uri.encodeFull('ueyue')}&body=${Uri.encodeFull('jeyy')}');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   }
  // }

  Future<void> callWhatsApp(String? phoneNumber) async {
    var androidUrl = "whatsapp://send?phone=+91$phoneNumber}";
    var iosUrl = "https://wa.me/$phoneNumber}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }
}
