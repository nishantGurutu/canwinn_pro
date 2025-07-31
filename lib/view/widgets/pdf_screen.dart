import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:task_management/constant/color_constant.dart';

class PDFScreen extends StatelessWidget {
  final File file;

  PDFScreen({required this.file});
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('pdf file path ${file}');
    return Scaffold(
      backgroundColor: whiteColor,
      appBar:
          AppBar(backgroundColor: whiteColor, title: const Text('PDF Viewer')),
      body: SfPdfViewer.file(
        file,
        key: _pdfViewerKey,
      ),
    );
  }
}

class NetworkPDFScreen extends StatelessWidget {
  final String file;

  NetworkPDFScreen({required this.file});
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('pdf file path ${file}');
    return Scaffold(
      backgroundColor: whiteColor,
      appBar:
          AppBar(backgroundColor: whiteColor, title: const Text('PDF Viewer')),
      body: SfPdfViewer.network(
        file.toString(),
        key: _pdfViewerKey,
      ),
    );
  }
}
