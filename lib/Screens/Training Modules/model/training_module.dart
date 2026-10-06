import '../../../../Utility/api_constants.dart';

class TrainingModule {
  final int? trainingDocumentId;
  final DateTime uploadedAt;
  final String title;
  final String description;
  final String originalFileName;
  final String storedFileName;
  final String contentType;
  final int? fileSizeBytes;
  final String? createdBy;
  final DateTime? createdOn;

  TrainingModule({
    this.trainingDocumentId,
    required this.uploadedAt,
    required this.title,
    required this.description,
    required this.originalFileName,
    required this.storedFileName,
    required this.contentType,
    this.fileSizeBytes,
    this.createdBy,
    this.createdOn,
  });

  factory TrainingModule.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return TrainingModule(
      trainingDocumentId: json['trainingDocumentId'],
      uploadedAt: parseDate(json['documentDate'] ?? json['createdOn']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      originalFileName:
          json['originalFileName'] ?? json['storedFileName'] ?? '',
      storedFileName: json['storedFileName'] ?? '',
      contentType: json['contentType'] ?? 'application/pdf',
      fileSizeBytes: json['fileSizeBytes'],
      createdBy: json['createdBy'],
      createdOn:
          json['createdOn'] != null ? parseDate(json['createdOn']) : null,
    );
  }

  String get fileName =>
      originalFileName.isNotEmpty ? originalFileName : storedFileName;

  String get fileType {
    final name = fileName;
    if (name.contains('.')) {
      final ext = name.split('.').last.toLowerCase();
      switch (ext) {
        case 'doc':
        case 'docx':
          return 'Word';
        case 'xls':
        case 'xlsx':
          return 'Excel';
        case 'jpeg':
        case 'jpg':
          return 'JPG';
        case 'png':
          return 'PNG';
        case 'pdf':
          return 'PDF';
        default:
          return ext.toUpperCase();
      }
    }
    return 'PDF';
  }

  String get pdfUrl {
    final name = storedFileName.isNotEmpty ? storedFileName : originalFileName;
    if (name.isEmpty) return '';
    if (name.startsWith('http://') || name.startsWith('https://')) {
      return name;
    }
    if (name.startsWith('/')) {
      return '${ApiConstant.baseUrl}$name';
    }
    return '${ApiConstant.baseUrl}/Uploads/$name';
  }
}

