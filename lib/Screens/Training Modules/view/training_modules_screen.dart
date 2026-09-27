import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aeon_hrms/constant.dart';

import '../data/sample_training_modules.dart';
import '../model/training_module.dart';

class TrainingModulesScreen extends StatefulWidget {
  const TrainingModulesScreen({super.key, this.modules});

  final List<TrainingModule>? modules;

  @override
  State<TrainingModulesScreen> createState() => _TrainingModulesScreenState();
}

class _TrainingModulesScreenState extends State<TrainingModulesScreen> {
  String _type = 'All';
  DateTime? _date;

  Color _color(String type) => switch (type) {
    'PDF' => const Color(0xffd74c4c),
    'Word' => const Color(0xff3869c9),
    'Excel' => const Color(0xff288451),
    _ => const Color(0xff9162c4),
  };

  IconData _icon(String type) => switch (type) {
    'PDF' => Icons.picture_as_pdf_outlined,
    'Word' => Icons.description_outlined,
    'Excel' => Icons.table_chart_outlined,
    _ => Icons.image_outlined,
  };

  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) setState(() => _date = date);
  }

  void _showDetails(TrainingModule module) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _icon(module.fileType),
                color: _color(module.fileType),
                size: 44,
              ),
              const SizedBox(height: 16),
              Text(
                module.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(module.fileName),
              const SizedBox(height: 8),
              Text(
                'Uploaded: ${DateFormat('dd MMM yyyy, hh:mm a').format(module.uploadedAt)}',
              ),
              const SizedBox(height: 16),
              Text(module.description),
              const SizedBox(height: 20),
              const Text(
                'Sample file only. Viewing and downloading will be available when uploaded files are connected.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fileCard(TrainingModule module) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xffe4e7ed)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _color(module.fileType).withValues(alpha: .1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_icon(module.fileType), color: _color(module.fileType)),
        ),
        title: Text(
          module.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${module.fileName}\n${module.fileType} • ${DateFormat('hh:mm a').format(module.uploadedAt)}',
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDetails(module),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final files =
        (widget.modules ?? sampleTrainingModules)
            .where(
              (module) =>
                  (_type == 'All' || module.fileType == _type) &&
                  (_date == null ||
                      DateUtils.isSameDay(module.uploadedAt, _date)),
            )
            .toList()
          ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    final groups = <DateTime, List<TrainingModule>>{};
    for (final file in files) {
      groups
          .putIfAbsent(DateUtils.dateOnly(file.uploadedAt), () => [])
          .add(file);
    }
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: const Text('Training Modules'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Training Library',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Browse training material by upload date.',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sample data',
                          style: TextStyle(
                            color: kMainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final type in [
                                'All',
                                'PDF',
                                'JPG',
                                'PNG',
                                'Word',
                                'Excel',
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(type),
                                    selected: _type == type,
                                    onSelected: (_) =>
                                        setState(() => _type = type),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _chooseDate,
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                              ),
                              label: Text(
                                _date == null
                                    ? 'All dates'
                                    : DateFormat('dd MMM yyyy').format(_date!),
                              ),
                            ),
                            if (_date != null)
                              TextButton(
                                onPressed: () => setState(() => _date = null),
                                child: const Text('Clear date'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${files.length} files • Newest first',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                if (groups.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No training files found for this selection.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                for (final group in groups.entries)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 4),
                            child: Text(
                              DateFormat('dd MMM yyyy').format(group.key),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kTitleColor,
                              ),
                            ),
                          );
                        }
                        return _fileCard(group.value[index - 1]);
                      }, childCount: group.value.length + 1),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
