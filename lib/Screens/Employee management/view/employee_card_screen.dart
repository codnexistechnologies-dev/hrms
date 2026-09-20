import 'dart:io';
import 'dart:ui' as ui;

import 'package:aeon_hrms/Screens/Employee%20management/model/employeeDetailsModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class EmployeeCardScreen extends StatefulWidget {
  final EmpType employee;

  const EmployeeCardScreen({required this.employee, super.key});

  @override
  State<EmployeeCardScreen> createState() => _EmployeeCardScreenState();
}

class _EmployeeCardScreenState extends State<EmployeeCardScreen> {
  bool _isWorking = false;
  bool _isDownloading = false;
  final GlobalKey _cardKey = GlobalKey();

  EmpType get employee => widget.employee;

  Future<void> _downloadCard() async {
    if (_isWorking) return;

    setState(() {
      _isWorking = true;
      _isDownloading = true;
    });

    try {
      // 1. Generate PDF
      final file = await EmployeeCardPdf._create(await _captureCard());

      debugPrint('PDF generated: ${file.path}');

      if (!await file.exists()) {
        throw Exception('PDF file was not created');
      }
      debugPrint('PDF size: ${await file.length()} bytes');

      // 2. File name
      final employeeCode = _value(employee, 'emPCODE');

      final fileName =
          'employee_card_${employeeCode.isNotEmpty ? employeeCode : 'employee'}.pdf';

      debugPrint('Saving PDF as: $fileName');

      // 3. Open Save File dialog
      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: fileName,
          mimeTypesFilter: const ['application/pdf'],
        ),
      );

      debugPrint('Saved path: $savedPath');

      if (!mounted) return;

      if (savedPath != null && savedPath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee card PDF saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Save cancelled')));
      }
    } catch (error, stackTrace) {
      debugPrint('PDF DOWNLOAD ERROR: $error');
      debugPrint('PDF DOWNLOAD STACK TRACE: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to download employee card: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _shareCard() async {
    await _runPdfAction((file) async {
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Employee ID card - ${_value(employee.emPNAME, '')}');
    });
  }

  Future<void> _runPdfAction(Future<void> Function(File file) action) async {
    if (_isWorking) return;
    setState(() => _isWorking = true);
    try {
      final file = await EmployeeCardPdf._create(await _captureCard());
      await action(file);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to create employee card: $error')),
      );
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<_CardCapture> _captureCard() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) throw StateError('Employee card screen is closed');

    final renderObject = _cardKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary || renderObject.size.isEmpty) {
      throw StateError('Employee card is not ready to export');
    }

    final image = await renderObject.toImage(pixelRatio: 2);
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('Unable to capture employee card');
      return _CardCapture(
        bytes: byteData.buffer.asUint8List(),
        width: image.width,
        height: image.height,
      );
    } finally {
      image.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        title: const Text('Employee ID Card'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: RepaintBoundary(
                key: _cardKey,
                child: EmployeeCardPreview(employee: employee),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isWorking ? null : _downloadCard,
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_outlined),
                      label: Text(
                        _isDownloading ? 'Downloading...' : 'Download PDF',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isWorking ? null : _shareCard,
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: kMainColor,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeCardPreview extends StatelessWidget {
  final EmpType employee;

  const EmployeeCardPreview({required this.employee, super.key});

  @override
  Widget build(BuildContext context) {
    final photo = _value(employee.emPPICT, '');
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffe4faee),
          border: Border.all(color: const Color(0xffffc107), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: _corner()),
            Positioned(top: 0, right: 0, child: _corner(right: true)),
            Positioned(bottom: 0, left: 0, child: _corner(bottom: true)),
            Positioned(
              bottom: 0,
              right: 0,
              child: _corner(right: true, bottom: true),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Column(
                children: [
                  Image.asset(
                    'images/company_card_logo.png',
                    height: 58,
                    width: 230,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  if (photo.isNotEmpty)
                    ClipOval(
                      child: Image.network(
                        '${ApiConstant.baseUrl}/Images/$photo',
                        height: 93,
                        width: 93,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _photoPlaceholder(),
                      ),
                    )
                  else
                    _photoPlaceholder(),
                  const SizedBox(height: 8),
                  _details(),
                  const Spacer(),
                  const Divider(
                    color: Color(0xffffc107),
                    thickness: 2,
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Reg.Office: 08 Raheja Arcade, Shahbaz Village, Sector -11,',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'CBD Belapur, Navi Mumbai, Maharashtra - 400614',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '(M) - 8588834481, Email ID: care@avayayaya.com',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffffc107),
                    thickness: 2,
                    height: 8,
                  ),
                  const Text(
                    'Terms & Condition',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '* This card relates only to the person described',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '* This card must be carried during duty hours and produced on demand to the designated authority',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text.rich(
        _nameSpan(_value(employee.emPNAME, 'N/A')),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: Color(0xff333333),
        ),
      ),
      const SizedBox(height: 3),
      Text(
        _value(employee.dsGNAME, 'N/A'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Color(0xff666666)),
      ),
      const SizedBox(height: 2),
      _row('ID no', _value(employee.emPCODE, 'N/A')),
      _row('Join Date', _formatDate(employee.doj)),
      _row('Phone', _value(employee.mobileno, 'N/A')),
      _row('Work Location', _value(employee.loCNAME, 'N/A')),
    ],
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 170),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2E671E),
                ),
              ),
            ),
            const Text(
              ':  ',
              style: TextStyle(fontSize: 11, color: Color(0xff444444)),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xff444444),
                  fontWeight: label == 'ID no'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  TextSpan _nameSpan(String name) {
    final parts = name.toUpperCase().split(RegExp(r'\s+'));
    return TextSpan(
      children: [
        if (parts.length > 1)
          TextSpan(text: '${parts.take(parts.length - 1).join(' ')} '),
        TextSpan(
          text: parts.last,
          style: const TextStyle(color: Color(0xffF5770F)),
        ),
      ],
    );
  }

  Widget _photoPlaceholder() => ClipOval(
    child: Image.network(
      '${ApiConstant.imageUrl}/${IMAGES}/${_value(employee.emPPICT, '')}',
      height: 93,
      width: 93,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 93,
        width: 93,
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(Icons.person, size: 52, color: Colors.grey),
      ),
    ),
  );

  Widget _corner({bool right = false, bool bottom = false}) => ClipPath(
    clipper: _CornerClipper(right: right, bottom: bottom),
    child: Container(width: 78, height: 50, color: const Color(0xffffbd00)),
  );
}

class _CornerClipper extends CustomClipper<Path> {
  final bool right;
  final bool bottom;

  _CornerClipper({required this.right, required this.bottom});

  @override
  Path getClip(Size size) {
    final x = right ? size.width : 0.0;
    final y = bottom ? size.height : 0.0;
    return Path()
      ..moveTo(x, y)
      ..lineTo(right ? 0.0 : size.width, y)
      ..lineTo(x, bottom ? 0.0 : size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _CornerClipper oldClipper) =>
      oldClipper.right != right || oldClipper.bottom != bottom;
}

class _CardCapture {
  final Uint8List bytes;
  final int width;
  final int height;

  const _CardCapture({
    required this.bytes,
    required this.width,
    required this.height,
  });
}

class EmployeeCardPdf {
  static Future<File> _create(_CardCapture capture) async {
    final document = PdfDocument();
    try {
      const pageWidth = 250.0;
      final pageHeight = pageWidth * capture.height / capture.width;
      document.pageSettings.size = Size(pageWidth, pageHeight);
      // The captured card fills the page. Default PDF margins would clip its
      // right and bottom edges because drawing is relative to the client area.
      document.pageSettings.margins.all = 0;
      final page = document.pages.add();

      page.graphics.drawImage(
        PdfBitmap(capture.bytes),
        Rect.fromLTWH(0, 0, pageWidth, pageHeight),
      );

      final bytes = Uint8List.fromList(await document.save());
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/employee_card.pdf');
      await file.writeAsBytes(bytes);
      return file;
    } finally {
      document.dispose();
    }
  }

  static Future<File> _createManual(EmpType employee) async {
    final document = PdfDocument();
    try {
      final page = document.pages.add();
      const cardWidth = 288.0;
      const cardHeight = 410.0;
      final yellowColor = PdfColor(255, 193, 7);

      page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(228, 250, 238)),
        bounds: const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
      );
      final yellow = PdfSolidBrush(yellowColor);
      final border = PdfPen(yellowColor, width: 3);
      page.graphics.drawRectangle(
        pen: border,
        bounds: const Rect.fromLTWH(1.5, 1.5, cardWidth - 3, cardHeight - 3),
      );
      page.graphics.drawPolygon(<Offset>[
        const Offset(0, 0),
        const Offset(78, 0),
        const Offset(0, 50),
      ], brush: yellow);
      page.graphics.drawPolygon(<Offset>[
        const Offset(cardWidth, 0),
        const Offset(cardWidth - 78, 0),
        const Offset(cardWidth, 50),
      ], brush: yellow);
      page.graphics.drawPolygon(<Offset>[
        const Offset(0, cardHeight),
        const Offset(78, cardHeight),
        const Offset(0, cardHeight - 50),
      ], brush: yellow);
      page.graphics.drawPolygon(<Offset>[
        const Offset(cardWidth, cardHeight),
        const Offset(cardWidth - 78, cardHeight),
        const Offset(cardWidth, cardHeight - 50),
      ], brush: yellow);

      final logo = PdfBitmap(
        (await rootBundle.load('images/company_card_logo.png')).buffer
            .asUint8List(),
      );
      page.graphics.drawImage(logo, const Rect.fromLTWH(29, 7, 230, 77));
      final photoBytes = await _photoBytes(employee);
      final photoState = page.graphics.save();
      page.graphics.setClip(
        path: PdfPath()..addEllipse(const Rect.fromLTWH(97.5, 77, 93, 93)),
      );
      if (photoBytes != null) {
        page.graphics.drawImage(
          PdfBitmap(photoBytes),
          const Rect.fromLTWH(97.5, 77, 93, 93),
        );
      } else {
        page.graphics.drawRectangle(
          brush: PdfSolidBrush(PdfColor(255, 255, 255)),
          bounds: const Rect.fromLTWH(97.5, 77, 93, 93),
        );
      }

      page.graphics.restore(photoState);
      final nameFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        17,
        style: PdfFontStyle.bold,
      );
      final nameParts = _value(
        employee.emPNAME,
        'N/A',
      ).toUpperCase().split(RegExp(r'\s+'));
      final firstNames = nameParts.length > 1
          ? '${nameParts.take(nameParts.length - 1).join(' ')} '
          : '';
      final nameWidth = nameFont
          .measureString('$firstNames${nameParts.last}')
          .width;
      final nameX = (cardWidth - nameWidth) / 2;
      _text(page, firstNames, nameX, 178, nameFont, width: nameWidth);
      _text(
        page,
        nameParts.last,
        nameX + nameFont.measureString(firstNames).width,
        178,
        nameFont,
        width: nameWidth,
        color: PdfColor(229, 57, 53),
      );
      _text(
        page,
        _value(employee.dsGNAME, 'N/A'),
        12,
        201,
        PdfStandardFont(PdfFontFamily.helvetica, 11),
        width: 264,
        center: true,
        color: PdfColor(102, 102, 102),
      );
      var y = 225.0;
      final rows = <List<String>>[
        ['ID no', _value(employee.emPCODE, 'N/A')],
        ['Join Date', _formatDate(employee.doj)],
        ['Phone', _value(employee.mobileno, 'N/A')],
        ['Work Location', _value(employee.loCNAME, 'N/A')],
      ];
      final bold = PdfStandardFont(
        PdfFontFamily.helvetica,
        11,
        style: PdfFontStyle.bold,
      );
      for (final row in rows) {
        final font = PdfStandardFont(PdfFontFamily.helvetica, 10);
        final labelFont = PdfStandardFont(
          PdfFontFamily.helvetica,
          10,
          style: PdfFontStyle.bold,
        );
        _text(
          page,
          row[0],
          24,
          y,
          labelFont,
          width: 90,
          color: PdfColor(229, 57, 53),
        );
        _text(page, ':', 116, y, font, width: 10);
        _text(
          page,
          row[1],
          130,
          y,
          row[0] == 'ID no' ? labelFont : font,
          width: 134,
        );
        y += 17;
      }
      page.graphics.drawLine(
        PdfPen(yellowColor, width: 2),
        Offset(12, y + 1),
        Offset(276, y + 1),
      );
      _text(
        page,
        'Reg.Office: 08 Raheja Arcade, Shahbaz Village, Sector -11,',
        12,
        y + 7,
        bold,
        width: 264,
        center: true,
      );
      _text(
        page,
        'CBD Belapur, Navi Mumbai, Maharashtra - 400614',
        12,
        y + 20,
        bold,
        width: 264,
        center: true,
      );
      _text(
        page,
        '(M) - 8588834481, Email ID: care@avayayaya.com',
        12,
        y + 33,
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        width: 264,
        center: true,
      );
      page.graphics.drawLine(
        PdfPen(yellowColor, width: 2),
        Offset(12, y + 48),
        Offset(276, y + 48),
      );
      _text(
        page,
        'Terms & Condition',
        12,
        y + 53,
        bold,
        width: 264,
        center: true,
      );
      _text(
        page,
        '* This card relates only to the person described',
        12,
        y + 68,
        PdfStandardFont(PdfFontFamily.helvetica, 9),
        width: 264,
        center: true,
      );
      _text(
        page,
        '* This card must be carried during duty hours and produced on demand to the designated authority',
        12,
        y + 81,
        PdfStandardFont(PdfFontFamily.helvetica, 9),
        width: 264,
        center: true,
      );

      final bytes = Uint8List.fromList(await document.save());
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/employee_card.pdf');
      await file.writeAsBytes(bytes);
      return file;
    } finally {
      document.dispose();
    }
  }

  static void _text(
    PdfPage page,
    String text,
    double x,
    double y,
    PdfFont font, {
    double width = 80,
    bool center = false,
    PdfColor? color,
  }) {
    PdfTextElement(
      text: text,
      font: font,
      brush: PdfSolidBrush(color ?? PdfColor(51, 51, 51)),
      format: PdfStringFormat(
        alignment: center ? PdfTextAlignment.center : PdfTextAlignment.left,
      ),
    ).draw(page: page, bounds: Rect.fromLTWH(x, y, width, 20));
  }

  static Future<Uint8List?> _photoBytes(EmpType employee) async {
    final photo = _value(employee.emPPICT, '');
    if (photo.isEmpty) return null;
    try {
      final response = await http
          .get(Uri.parse('${ApiConstant.baseUrl}/Images/$photo'))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } on Exception catch (error) {
      debugPrint('EMPLOYEE PHOTO DOWNLOAD ERROR: $error');
      return null;
    }
  }
}

String _value(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty || text == 'null' ? fallback : text;
}

String _formatDate(dynamic value) {
  final text = _value(value, 'N/A');
  if (text == 'N/A') return text;
  return text.length >= 10
      ? text.substring(0, 10).split('-').reversed.join('-')
      : text;
}
