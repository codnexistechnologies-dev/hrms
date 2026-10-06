import '../model/training_module.dart';

// Static examples until the training upload API is available.
final sampleTrainingModules = <TrainingModule>[
  TrainingModule(
    title: 'Product Knowledge Guide',
    originalFileName: 'product_knowledge.pdf',
    storedFileName: 'product_knowledge.pdf',
    contentType: 'application/pdf',
    uploadedAt: DateTime(2026, 9, 23, 15, 30),
    description: 'Product features, application guidance and frequently asked questions.',
  ),
  TrainingModule(
    title: 'Field Visit Checklist',
    originalFileName: 'field_visit_checklist.docx',
    storedFileName: 'field_visit_checklist.docx',
    contentType: 'application/msword',
    uploadedAt: DateTime(2026, 9, 23, 11),
    description: 'Preparation and follow-up checklist for field visits.',
  ),
  TrainingModule(
    title: 'Crop Care Poster',
    originalFileName: 'crop_care.jpg',
    storedFileName: 'crop_care.jpg',
    contentType: 'image/jpeg',
    uploadedAt: DateTime(2026, 9, 22, 16),
    description: 'Visual reference for crop care training.',
  ),
  TrainingModule(
    title: 'Product Application Chart',
    originalFileName: 'application_chart.png',
    storedFileName: 'application_chart.png',
    contentType: 'image/png',
    uploadedAt: DateTime(2026, 9, 22, 10, 15),
    description: 'Illustrated application steps for the training session.',
  ),
  TrainingModule(
    title: 'Monthly Training Schedule',
    originalFileName: 'training_schedule.xlsx',
    storedFileName: 'training_schedule.xlsx',
    contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    uploadedAt: DateTime(2026, 9, 21, 14),
    description: 'Session dates, topics and trainer details.',
  ),
  TrainingModule(
    title: 'Farmer Meeting Handbook',
    originalFileName: 'farmer_meeting.pdf',
    storedFileName: 'farmer_meeting.pdf',
    contentType: 'application/pdf',
    uploadedAt: DateTime(2026, 9, 20, 9, 30),
    description: 'Discussion topics and guidance for farmer meetings.',
  ),
];
