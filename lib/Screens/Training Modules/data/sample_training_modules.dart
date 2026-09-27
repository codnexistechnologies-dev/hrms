import '../model/training_module.dart';

// Static examples until the training upload API is available.
final sampleTrainingModules = <TrainingModule>[
  TrainingModule(
    title: 'Product Knowledge Guide',
    fileName: 'product_knowledge.pdf',
    uploadedAt: DateTime(2026, 9, 23, 15, 30),
    description: 'Product features, application guidance and frequently asked questions.',
  ),
  TrainingModule(
    title: 'Field Visit Checklist',
    fileName: 'field_visit_checklist.docx',
    uploadedAt: DateTime(2026, 9, 23, 11),
    description: 'Preparation and follow-up checklist for field visits.',
  ),
  TrainingModule(
    title: 'Crop Care Poster',
    fileName: 'crop_care.jpg',
    uploadedAt: DateTime(2026, 9, 22, 16),
    description: 'Visual reference for crop care training.',
  ),
  TrainingModule(
    title: 'Product Application Chart',
    fileName: 'application_chart.png',
    uploadedAt: DateTime(2026, 9, 22, 10, 15),
    description: 'Illustrated application steps for the training session.',
  ),
  TrainingModule(
    title: 'Monthly Training Schedule',
    fileName: 'training_schedule.xlsx',
    uploadedAt: DateTime(2026, 9, 21, 14),
    description: 'Session dates, topics and trainer details.',
  ),
  TrainingModule(
    title: 'Farmer Meeting Handbook',
    fileName: 'farmer_meeting.pdf',
    uploadedAt: DateTime(2026, 9, 20, 9, 30),
    description: 'Discussion topics and guidance for farmer meetings.',
  ),
];
