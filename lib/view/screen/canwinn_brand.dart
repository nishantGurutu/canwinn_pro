import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/brand_image_controller.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/view/widgets/image_screen.dart';

class BrandingImage extends StatefulWidget {
  const BrandingImage({super.key});

  @override
  State<BrandingImage> createState() => _BrandingImageState();
}

class _BrandingImageState extends State<BrandingImage> {
  final BrandingImageController brandingImageController =
      Get.put(BrandingImageController());
  @override
  void initState() {
    brandingImageController.brandImageList('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          brandingImage,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => brandingImageController.isBrandingImageLoading.value == true
            ? Container(
                height: 700.h,
                child: Center(child: CircularProgressIndicator()),
              )
            : brandingImageController.brandImages.isEmpty
                ? Center(
                    child: Text("No images found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  )
                : Container(
                    height: 700.h,
                    color: backgroundColor,
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: brandingImageController.brandImages.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => NetworkImageScreen(
                                        file: brandingImageController
                                                .brandImages[index].image ??
                                            '',
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                    color: whiteColor,
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                    child: Obx(
                                      () {
                                        final imageUrl = brandingImageController
                                                .brandImages[index].image ??
                                            '';
                                        return imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.r),
                                                      ),
                                                    ),
                                                    child: Image.asset(
                                                        backgroundLogo),
                                                  );
                                                },
                                              )
                                            : SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 10.w,
                                child: InkWell(
                                  onTap: () async {
                                    final imageUrl = brandingImageController
                                            .brandImages[index].image ??
                                        "";
                                    final link = brandingImageController
                                            .brandImages[index].link ??
                                        "";
                                    final url = Uri.parse(imageUrl);
                                    final response = await http.get(url);
                                    final contentType =
                                        response.headers['content-type'];
                                    final image = XFile.fromData(
                                      response.bodyBytes,
                                      mimeType: contentType,
                                    );
                                    await Share.shareXFiles([image],
                                        text: link);
                                  },
                                  child: Container(
                                    height: 25.h,
                                    width: 25.w,
                                    decoration: BoxDecoration(
                                      color: lightBorderColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.5.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.share,
                                        size: 16.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
