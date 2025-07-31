import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class DownloadCode {
  Future<void> saveToDownloads(String filePath,
      {required bool isNetwork}) async {
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


      if (isNetwork) {
        Dio dio = Dio();
        await dio.download(filePath, appFilePath);
        await dio.download(filePath, downloadFilePath);
      } else {
        File file = File(filePath);
        await file.copy(downloadFilePath);
      }

      Fluttertoast.showToast(msg: 'File saved to App Storage & Downloads');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving file: $e');
    }
  }
}
