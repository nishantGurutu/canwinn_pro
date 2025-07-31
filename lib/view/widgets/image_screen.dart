import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/constant/color_constant.dart';

class ImageScreen extends StatelessWidget {
  final File file;

  const ImageScreen({required this.file});

  Future<void> downloadImage(BuildContext context) async {
    await saveToDownloads(file.toString(), isNetwork: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Image.asset(
              'assets/images/png/Download.png',
              height: 28.h,
            ),
          ),
        ],
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Image.file(file),
        ),
      ),
    );
  }
}

Future<void> saveToDownloads(String filePath, {required bool isNetwork}) async {
  try {
    Directory appDir = await getApplicationDocumentsDirectory();
    String appSavePath = '${appDir.path}/saved_files';

    Directory appSaveDir = Directory(appSavePath);
    if (!appSaveDir.existsSync()) {
      appSaveDir.createSync(recursive: true);
    }

    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    final now = DateTime.now();
    final fileName = "download_${now.millisecondsSinceEpoch}.jpg";

    final appFilePath = '$appSavePath/$fileName';
    final downloadFilePath = '${downloadsDir.path}/$fileName';

    File? savedFile;

    if (isNetwork) {
      Dio dio = Dio();
      await dio.download(filePath, appFilePath);
      await dio.download(filePath, downloadFilePath);
      savedFile = File(appFilePath);
    } else {
      File file = File(filePath);
      savedFile = await file.copy(appFilePath);
      await file.copy(downloadFilePath);
    }

    Fluttertoast.showToast(msg: 'File saved to App Storage & Downloads');
    print('Saved in app: $appFilePath');
    print('Downloaded to: $downloadFilePath');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error saving file: $e');
  }
}

class NetworkImageScreen extends StatelessWidget {
  final String file;

  const NetworkImageScreen({required this.file});

  Future<void> downloadImage(BuildContext context) async {
    await saveToDownloads(file, isNetwork: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              downloadImage(context);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Image.asset(
                'assets/images/png/Download.png',
                height: 28.h,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Center(child: Image.network(file.toString())),
      ),
    );
  }
}
