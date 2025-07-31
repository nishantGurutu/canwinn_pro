// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/get_submit_daily_task_model.dart';

class SubmittedTaskPdfReport {
  final RxList<SubmitDailyTasksData> previousSubmittedTask;
  final int? completedCount;
  final String? dateText;
  SubmittedTaskPdfReport(
      this.previousSubmittedTask, this.completedCount, this.dateText);

  Future<Uint8List> loadImage() async {
    final ByteData data =
        await rootBundle.load("assets/images/png/Layer_x0020_1.png");
    return data.buffer.asUint8List();
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final Uint8List imageBytes = await loadImage();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          pageFormat: PdfPageFormat.a4.landscape,
        ),
        build: (context) {
          return [
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                width: 100,
                height: 100,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              color: PdfColors.green,
              padding: pw.EdgeInsets.all(10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    ' ',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.Text(
                    'MY DAILY CANWINN TASK CHECK LIST',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.Text(
                    'Date: $dateText',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    ' ',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${completedCount}/${previousSubmittedTask.length} : SUBMITTED TASK',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '$dateText ',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.Table.fromTextArray(
              headerDecoration: pw.BoxDecoration(color: PdfColors.green),
              headerHeight: 25,
              cellHeight: 30,
              headers: ['Ser No', 'Time', 'Task', ' Done/Not Done', 'Remarks'],
              data: previousSubmittedTask.map((task) {
                return [
                  task.id,
                  task.doneTime ?? "",
                  task.taskName ?? "",
                  task.status == 1 ? ' Done' : 'X Not Done',
                  task.remarks ?? '',
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      'Regards',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '${StorageHelper.getName()} ',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final folderPath = directory.path;
    final now = DateTime.now();
    final formattedDate = '${now.month}-${now.day}-${now.year}_${now.second}';
    final String filePath = '$folderPath/report_$formattedDate.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (await file.exists()) {
      await downloadPDF(filePath);
    }
  }

  Future<void> downloadPDF(String filePath) async {
    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';

      final downloadPath =
          '/storage/emulated/0/Download/submitted_task_report_$formattedDate.pdf';

      final file = File(filePath);

      if (await file.exists()) {
        final downloadFile = File(downloadPath);

        if (await downloadFile.exists()) {
          await downloadFile.delete();
        }
        await file.copy(downloadPath);
        Fluttertoast.showToast(
          msg: 'Download in download folder',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        print('ksjoiwo lwokpo lem $downloadPath');
        // Get.to(() => PDFScreen(file: File(downloadPath)));
      } else {}
    } catch (e) {}
  }
}
