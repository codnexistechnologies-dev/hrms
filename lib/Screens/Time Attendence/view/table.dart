import 'package:flutter/material.dart';
//import 'package:nb_utils/nb_utils.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
            ),
          ],
        ),
      ),
    );
  }
}
