import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile {
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

      Fluttertoast.showToast(msg: 'File saved to Document');
      print('Saved in app: $appFilePath');
      print('Downloaded to: $downloadFilePath');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving file: $e');
    }
  }

  // Future<void> saveToDownloads(String filePath,
  //     {required bool isNetwork}) async {
  //   try {
  //     // Request Storage Permission
  //     var status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       Fluttertoast.showToast(msg: 'Storage permission denied');
  //       return;
  //     }

  //     Directory appDir = await getApplicationDocumentsDirectory();
  //     String appSavePath = '${appDir.path}/saved_files';

  //     Directory appSaveDir = Directory(appSavePath);
  //     if (!appSaveDir.existsSync()) {
  //       appSaveDir.createSync(recursive: true);
  //     }

  //     final now = DateTime.now();
  //     final fileName = "download_${now.millisecondsSinceEpoch}.jpg";

  //     final appFilePath = '$appSavePath/$fileName';

  //     File? savedFile;

  //     if (isNetwork) {
  //       Dio dio = Dio();
  //       await dio.download(filePath, appFilePath);
  //       savedFile = File(appFilePath);
  //     } else {
  //       File file = File(filePath);
  //       savedFile = await file.copy(appFilePath);
  //     }

  //     // Save to Downloads Folder using MediaStore
  //     if (savedFile != null && await savedFile.exists()) {
  //       final MediaStorePlus mediaStore = MediaStorePlus();
  //       await mediaStore.saveFile(
  //         filePath: savedFile.path,
  //         relativePath: 'Download',
  //         mimeType: 'image/jpeg',
  //       );
  //     }

  //     Fluttertoast.showToast(msg: 'File saved to App Storage & Downloads');
  //     print('Saved in app: $appFilePath');
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error saving file: $e');
  //   }
  // }
}
