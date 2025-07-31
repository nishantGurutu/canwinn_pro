import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:task_management/model/report_model.dart';

class CustomPdf {
  final Data? data;
  CustomPdf(
    this.data,
  );

  Future<pw.Font> loadFont() async {
    final fontData =
        await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          pageFormat: PdfPageFormat.a4.landscape,
        ),
        build: (context) {
          return [
            pw.Header(
              level: 1,
              child: pw.Text(
                'Task Report',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  child: pw.Text(
                    'Total Task ${data?.totalTask ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                pw.Container(
                  child: pw.Text(
                    'Today Project ${data?.totalProject ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                pw.Container(
                  child: pw.Text(
                    'Completed Project ${data?.completedTask ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                pw.Container(
                  child: pw.Text(
                    'New Project ${data?.newTask ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                pw.Container(
                  child: pw.Text(
                    'Progress Project ${data?.progressTask ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                pw.Container(
                  child: pw.Text(
                    'Total Project Assigned ${data?.totalProjectAssigned ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final folderPath = directory.path;

    final now = DateTime.now();
    final formattedDate =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
    final fileName = 'report_${formattedDate}.pdf';
    final filePath = '$folderPath/$fileName';
    print('afc agfgadg agfag $fileName');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (await file.exists()) {
      await downloadPDF(filePath);
    } else {}
  }

  Future<void> downloadPDF(String filePath) async {
    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
      final downloadPath =
          '/storage/emulated/0/Download/task_report$formattedDate.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        final downloadFile = File(downloadPath);

        if (await downloadFile.exists()) {
          await downloadFile.delete();
          print('Existing task_report.pdf deleted.');
        }

        await file.copy(downloadPath);
        Fluttertoast.showToast(
          msg: 'Download in download folder',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        print('PDF downloaded successfully.');
      } else {
        print('PDF file does not exist.');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }
}
