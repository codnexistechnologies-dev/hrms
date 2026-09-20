import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ErrorListScreen extends StatefulWidget {
  const ErrorListScreen({super.key});

  @override
  _ErrorListScreenState createState() => _ErrorListScreenState();
}

class _ErrorListScreenState extends State<ErrorListScreen> {
  List<Map<String, dynamic>> _error = [];

  @override
  void initState() {
    super.initState();
    _loadError();
  }

  void _loadError() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> error = await dbHelper.getUnsyncedErrors();
    setState(() {
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error List'),
      ),
      body: ListView.builder(
        itemCount: _error.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Employee Code: ${_error[index]['emp_code']}'),
            subtitle: Text('Date: ${_error[index]['error_date']}\n'
                'error_message: ${_error[index]['error_message']}\n'
                'flag: ${_error[index]['flag']}'),
          );
        },
      ),
    );
  }
}
