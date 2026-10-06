import 'dart:convert';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:aeon_hrms/constant.dart';

import '../data/sample_training_modules.dart';
import '../model/training_module.dart';
import 'training_pdf_viewer_screen.dart';

class TrainingModulesScreen extends StatefulWidget {
  const TrainingModulesScreen({super.key, this.modules});

  final List<TrainingModule>? modules;

  @override
  State<TrainingModulesScreen> createState() => _TrainingModulesScreenState();
}

class _TrainingModulesScreenState extends State<TrainingModulesScreen> {
  String _type = 'All';
  DateTime? _date;

  bool _isLoading = true;
  String? _errorMessage;
  List<TrainingModule> _apiModules = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainingDocuments();
  }

  Future<void> _fetchTrainingDocuments() async {
    if (widget.modules != null) {
      setState(() {
        _apiModules = widget.modules!;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConstant.baseUrl}/api/Traning/GetTraningDocumentList',
            ),
            headers: {'accept': '*/*'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body != null && body['data'] is List) {
          final List rawList = body['data'];
          if (mounted) {
            setState(() {
              _apiModules = rawList
                  .map((item) => TrainingModule.fromJson(item))
                  .toList();
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to load documents (HTTP ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching training documents: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading training documents: $e';
          _isLoading = false;
        });
      }
    }
  }

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

  void _openPdfViewer(TrainingModule module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingPdfViewerScreen(module: module),
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
          module.title.isNotEmpty ? module.title : module.fileName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${module.fileName}\n${module.fileType} • ${DateFormat('hh:mm a').format(module.uploadedAt)}'
            '${module.createdBy != null ? ' • By ${module.createdBy}' : ''}',
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openPdfViewer(module),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final fileList = _apiModules.isNotEmpty
        ? _apiModules
        : (widget.modules ?? sampleTrainingModules);

    final files =
        fileList
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

    final sortedDates = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: const Text('Training Modules'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTrainingDocuments,
            tooltip: 'Refresh',
          ),
        ],
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: kMainColor),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchTrainingDocuments,
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
                                Text(
                                  '${files.length} files • Newest first',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        if (_errorMessage != null && _apiModules.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.cloud_off_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _fetchTrainingDocuments,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else if (groups.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'No training files found.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        else
                          for (final dateKey in sortedDates)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(dateKey),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: kTitleColor,
                                          ),
                                        ),
                                      );
                                    }
                                    final moduleList = groups[dateKey]!;
                                    return _fileCard(moduleList[index - 1]);
                                  },
                                  childCount:
                                      (groups[dateKey]?.length ?? 0) + 1,
                                ),
                              ),
                            ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
