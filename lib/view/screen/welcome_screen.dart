import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/view/screen/unauthorised/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;
  late PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: 5,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  final screens = [
                    fiveScreen(),
                    firstScreen(),
                    secondScreen(),
                    thirdScreen(),
                    fourScreen(),
                  ];
                  return screens[index];
                },
              ),
              Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        welcomeToCanwinn,
                        style: changeTextColor(mediumSizeText, textColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          skip,
                          style: changeTextColor(
                              secondaryMediumSizeText, secondaryColor),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => buildDot(index),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if (currentIndex == 4) {
                            Get.to(LoginScreen());
                          } else {
                            _controller.animateToPage(
                              currentIndex + 1,
                              duration: Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        },
                        child: Container(
                          width: 100.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              next,
                              textAlign: TextAlign.center,
                              style: changeTextColor(rubikBlack, whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstScreen() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/gif/chat1.gif',
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                chatAndVideoCall,
                style: changeTextColor(boldText, textColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                stayConnectedWorkRemotelyAndEngageInWorkActivates,
                style: changeTextColor(smallText, secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 200.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget secondScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/gif/Group 14.gif',
                  width: 300.w,
                ),
              ),
            ],
          ),
        ),
        Text(
          taskAndProjects,
          style: changeTextColor(boldText, textColor),
        ),
        Text(
          toHelpYouStick,
          style: changeTextColor(smallText, secondaryTextColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          discussTaskAndPayAttention,
          style: changeTextColor(smallText, secondaryTextColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 200.h,
        ),
      ],
    );
  }

  Widget thirdScreen() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/gif/Main Scene 1.gif',
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                feed,
                style: changeTextColor(boldText, textColor),
                textAlign: TextAlign.center,
              ),
              Text(
                aidsCommunication,
                style: changeTextColor(smallText, secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                yourTermVirtualSpace,
                style: changeTextColor(smallText, secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 200.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fourScreen() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/gif/🟢 Figma to Lottie ✨.gif',
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                crm,
                style: changeTextColor(boldText, textColor),
                textAlign: TextAlign.center,
              ),
              Text(
                toHelpYouSellMore,
                style: changeTextColor(smallText, secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                neverMissaCustommer,
                style: changeTextColor(smallText, secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 200.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fiveScreen() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/png/_2093978688240.png',
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/png/Vector 1.png',
                    width: 18.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    collaboration,
                    style: changeTextColor(mediumSizeText, secondaryTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/png/Vector 1.png',
                    width: 18.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    taskAndProjects,
                    style: changeTextColor(mediumSizeText, secondaryTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/png/Vector 1.png',
                    width: 18.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    crm,
                    style: changeTextColor(mediumSizeText, secondaryTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/png/Vector 1.png',
                    width: 18.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    driveAndOnlineDocuments,
                    style: changeTextColor(mediumSizeText, secondaryTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/png/Vector 1.png',
                    width: 18.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    sitesAndOnlineStores,
                    style: changeTextColor(mediumSizeText, secondaryTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 200.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 7.h,
      width: currentIndex == index ? 35.w : 10.w,
      margin: EdgeInsets.only(right: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: dotColor,
      ),
    );
  }
}
