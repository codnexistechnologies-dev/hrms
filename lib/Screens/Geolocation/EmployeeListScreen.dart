import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> employees = await dbHelper.getEmployees();
    setState(() {
      _employees = employees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: ListView.builder(
        itemCount: _employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Employee Code: ${_employees[index]['emp_code']}'),
            subtitle: Text('Date: ${_employees[index]['atdate']}\n'
                'In/Out Date: ${_employees[index]['in_out_date']}\n'
                'Latitude: ${_employees[index]['LATITUDE']}\n'
                'Longitude: ${_employees[index]['LONGITUDE']}\n'
                'Address: ${_employees[index]['ADDRESS']}\n'
                'Network: ${_employees[index]['MOBILE_NETWORK']}\n'
                'flag: ${_employees[index]['flag']}'),
          );
        },
      ),
    );
  }
}
