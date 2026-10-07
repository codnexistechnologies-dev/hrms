import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constant.dart';
import '../../../../Utility/api_constants.dart';
import '../model/training_module.dart';

class TrainingPdfViewerScreen extends StatefulWidget {
  final TrainingModule module;

  const TrainingPdfViewerScreen({super.key, required this.module});

  @override
  State<TrainingPdfViewerScreen> createState() =>
      _TrainingPdfViewerScreenState();
}

class _TrainingPdfViewerScreenState extends State<TrainingPdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isDownloading = false;
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> _downloadPdf() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading file...'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      final pdfUrl =
          "${ApiConstant.imageUrl}/TrainingDocuments/${widget.module.storedFileName}";
      if (pdfUrl.isEmpty) {
        throw Exception('File URL is empty');
      }

      http.Response response = await http
          .get(Uri.parse(pdfUrl))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200 &&
          widget.module.storedFileName.isNotEmpty) {
        final fallbackUrl =
            '${ApiConstant.baseUrl}/${widget.module.storedFileName}';
        response = await http
            .get(Uri.parse(fallbackUrl))
            .timeout(const Duration(seconds: 30));
      }

      if (response.statusCode != 200) {
        throw HttpException('Download failed (HTTP ${response.statusCode})');
      }

      final dir = await getTemporaryDirectory();
      final fileName = widget.module.fileName.isNotEmpty
          ? widget.module.fileName
          : 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes, flush: true);

      if (!mounted) return;

      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: fileName,
          mimeTypesFilter: const ['application/pdf'],
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            savedPath != null ? 'PDF saved successfully.' : 'Save cancelled.',
          ),
          backgroundColor: savedPath != null ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      debugPrint('Error downloading PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.module.title.isNotEmpty
        ? widget.module.title
        : widget.module.fileName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isDownloading)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.file_download),
              tooltip: 'Download PDF',
              onPressed: _downloadPdf,
            ),
        ],
      ),
      body: _hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load PDF preview.\n$_errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _errorMessage = '';
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : SfPdfViewer.network(
              "${ApiConstant.imageUrl}/TrainingDocuments/${widget.module.storedFileName}",
              key: _pdfViewerKey,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _hasError = true;
                  _errorMessage = details.description;
                });
              },
            ),
    );
  }
}
