import 'package:flutter/material.dart';
import 'done_page.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerCustomerNo = TextEditingController();
  final TextEditingController _controllerBranchNo = TextEditingController();
  final TextEditingController _controllerCreditCode = TextEditingController();
  final TextEditingController _controllerCartonNo = TextEditingController();
  final TextEditingController _controllerCreditType = TextEditingController();
  final TextEditingController _controllerBalance = TextEditingController();
  final TextEditingController _controllerAuthorizationCode = TextEditingController();
  final TextEditingController _controllerStatusCode = TextEditingController();

  DateTime? _selectedIntikalDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedIntikalDate) {
      setState(() {
        _selectedIntikalDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Page'),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controllerID,
                decoration: const InputDecoration(
                  labelText: 'Enter ID',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerFirstName,
                decoration: const InputDecoration(
                  labelText: 'Enter First Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerLastName,
                decoration: const InputDecoration(
                  labelText: 'Enter Last Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerCustomerNo,
                decoration: const InputDecoration(
                  labelText: 'Enter Customer No',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerBranchNo,
                decoration: const InputDecoration(
                  labelText: 'Enter Branch No',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerCreditCode,
                decoration: const InputDecoration(
                  labelText: 'Enter Credit Code',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerCartonNo,
                decoration: const InputDecoration(
                  labelText: 'Enter Carton No',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerCreditType,
                decoration: const InputDecoration(
                  labelText: 'Enter Credit Type',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerBalance,
                decoration: const InputDecoration(
                  labelText: 'Enter Balance',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerAuthorizationCode,
                decoration: const InputDecoration(
                  labelText: 'Enter Authorization Code',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerStatusCode,
                decoration: const InputDecoration(
                  labelText: 'Enter Status Code',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Intikal Date'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonePage(
                        id: int.parse(_controllerID.text),
                        firstName: _controllerFirstName.text,
                        lastName: _controllerLastName.text,
                        customerNo: _controllerCustomerNo.text,
                        branchNo: _controllerBranchNo.text,
                        creditCode: _controllerCreditCode.text,
                        cartonNo: _controllerCartonNo.text,
                        creditType: _controllerCreditType.text,
                        balance: double.parse(_controllerBalance.text),
                        authorizationCode: _controllerAuthorizationCode.text,
                        statusCode: _controllerStatusCode.text,
                        intikalDate: _selectedIntikalDate!, // Intikal Date Ekleniyor
                      ),
                    ),
                  );
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
