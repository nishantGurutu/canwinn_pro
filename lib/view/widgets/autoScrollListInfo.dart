import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/view/screen/message.dart';

class AutoScrollList extends StatefulWidget {
  final RxList anniversaryListData;

  AutoScrollList(this.anniversaryListData);

  @override
  _AutoScrollListState createState() => _AutoScrollListState();
}

class _AutoScrollListState extends State<AutoScrollList> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
          AssetImage('assets/images/png/birthday_creative_image.png'), context);
      precacheImage(
          AssetImage('assets/images/png/Happy_Anniversary.png'), context);
      precacheImage(AssetImage('assets/images/png/fallback.png'), context);
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_pageController.hasClients && widget.anniversaryListData.isNotEmpty) {
        if (_currentPage < widget.anniversaryListData.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Container(
        height: 130.h,
        width: double.infinity,
        child: widget.anniversaryListData.isEmpty
            ? Center(
                child: Text('No events available',
                    style: TextStyle(fontSize: 16.sp)))
            : PageView.builder(
                controller: _pageController,
                itemCount: widget.anniversaryListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final eventType = widget.anniversaryListData[index]
                              ['event_type']
                          ?.toString()
                          .toLowerCase() ??
                      '';
                  final name =
                      widget.anniversaryListData[index]['name']?.toString() ??
                          'Unknown';
                  final roleName = widget.anniversaryListData[index]
                              ['role_name']
                          ?.toString() ??
                      'No Role';
                  final imageUrl =
                      widget.anniversaryListData[index]['image']?.toString() ??
                          '';
                  final chatId = widget.anniversaryListData[index]['chat_id']
                          ?.toString() ??
                      '';
                  final id =
                      widget.anniversaryListData[index]['id']?.toString() ?? '';

                  final imagePath = eventType == 'birthday'
                      ? 'assets/images/png/birthday_creative_image.png'
                      : 'assets/images/png/Happy_Anniversary.png';

                  return InkWell(
                    onTap: () {
                      Get.to(
                        MessageScreen(
                          name,
                          chatId,
                          id,
                          '',
                          [],
                          '',
                          '',
                          '',
                          'anniversary',
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(11.r)),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print(
                                    'Error loading image for index $index: $exception');
                              },
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      eventType == 'birthday'
                                          ? '🎉 Happy Birthday $name!'
                                          : '🎉 Happy Anniversary $name!',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2.0,
                                            color: Colors.black54,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      roleName,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: textColor,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2.0,
                                            color: Colors.black54,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : AssetImage(
                                              'assets/images/png/fallback.png')
                                          as ImageProvider,
                                  onBackgroundImageError: imageUrl.isNotEmpty
                                      ? (exception, stackTrace) {
                                          print(
                                              'Error loading network image for $name: $exception');
                                        }
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Icon(Icons.person,
                                          size: 30.r, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
