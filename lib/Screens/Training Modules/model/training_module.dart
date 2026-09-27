class TrainingModule {
  final String title;
  final String fileName;
  final DateTime uploadedAt;
  final String description;

  const TrainingModule({
    required this.title,
    required this.fileName,
    required this.uploadedAt,
    required this.description,
  });

  String get fileType {
    switch (fileName.split('.').last.toLowerCase()) {
      case 'doc':
      case 'docx':
        return 'Word';
      case 'xls':
      case 'xlsx':
        return 'Excel';
      case 'jpeg':
        return 'JPG';
      default:
        return fileName.split('.').last.toUpperCase();
    }
  }
}
