import 'package:flutter/material.dart';
import 'package:aeon_hrms/constant.dart';

class PreviewField {
  final String label, value;
  final List<String>? options;
  final bool date;
  final int lines;
  const PreviewField(
    this.label, [
    this.value = '',
    this.options,
    this.date = false,
    this.lines = 1,
  ]);
}

class PreviewSection {
  final String title;
  final IconData icon;
  final List<PreviewField> fields;
  const PreviewSection(this.title, this.icon, this.fields);
}

class KpiEntryPreview extends StatefulWidget {
  final String title, subtitle;
  final List<PreviewSection> sections;
  const KpiEntryPreview({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sections,
  });
  @override
  State<KpiEntryPreview> createState() => _KpiEntryPreviewState();
}

class _KpiEntryPreviewState extends State<KpiEntryPreview> {
  final Map<String, DateTime> dates = {};
  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    alignLabelWithHint: true,
    filled: true,
    fillColor: const Color(0xfffafbfd),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xffdce3ef)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
  );
  Widget field(PreviewField field) {
    Widget input;
    if (field.date) {
      final date = dates[field.label] ?? DateTime.now();
      input = InkWell(
        onTap: () async {
          final selected = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (selected != null && mounted)
            setState(() => dates[field.label] = selected);
        },
        child: InputDecorator(
          decoration: decoration(field.label).copyWith(
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
          ),
          child: Text(date.toString().substring(0, 10)),
        ),
      );
    } else if (field.options != null) {
      input = DropdownButtonFormField<String>(
        initialValue: field.options!.first,
        isExpanded: true,
        decoration: decoration(field.label),
        items: field.options!
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (_) {},
      );
    } else {
      input = TextFormField(
        initialValue: field.value,
        maxLines: field.lines,
        decoration: decoration(field.label),
        keyboardType: field.label.contains('Mobile')
            ? TextInputType.phone
            : TextInputType.text,
      );
    }
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: input);
  }

  Widget section(PreviewSection section) => Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xffe3e9f2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(section.icon, color: kMainColor, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTitleColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...section.fields.map(field),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff3f6fb),
    appBar: AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      backgroundColor: kMainColor,
      foregroundColor: Colors.white,
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kTitleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Color(0xff657187), height: 1.5),
              ),
              const SizedBox(height: 14),
              const Text(
                'DESIGN PREVIEW • Sample data only',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: kMainColor,
                ),
              ),
              const SizedBox(height: 20),
              ...widget.sections.map(section),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      color: kMainColor,
                      size: 36,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Visit photo',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Photo attachment is a placeholder for this preview.',
                              ),
                            ),
                          ),
                      child: const Text('Add photo'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: kMainColor),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Submit entry'),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Preview only'),
                      content: const Text(
                        'This sample form is for review. No entry has been saved or submitted.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
