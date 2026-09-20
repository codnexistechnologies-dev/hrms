import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final String paysliPPath;
  final bool isLocal; const ViewPdf(this.paysliPPath, {super.key, this.isLocal = false});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    _pdfViewerKey.currentState?.openBookmarkView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget pdf url ${widget.paysliPPath}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "View PDF",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: widget.isLocal ? SfPdfViewer.file(File(widget.paysliPPath), key: _pdfViewerKey) : SfPdfViewer.network(
        widget.paysliPPath,
        key: _pdfViewerKey,
      ),
    );
  }
}
