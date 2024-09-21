import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Future<List<Person>> _personListFuture;

  @override
  void initState() {
    super.initState();
    _personListFuture = fetchPersons();
  }

  // Kişileri veritabanından alan fonksiyon
  Future<List<Person>> fetchPersons() async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/person/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Person.fromJson(item)).toList();
    } else {
      throw Exception('Kişiler alınamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Person'),
      ),
      body: FutureBuilder<List<Person>>(
        future: _personListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Kişi bulunamadı.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final person = snapshot.data![index];
                return ListTile(
                  title: Text('${person.firstName} ${person.lastName}'),
                  subtitle: Text('Müşteri No: ${person.customerNo}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPersonPage(person: person, onSave: _updatePerson),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Bir kişiyi güncellemek için bu metodu kullanabilirsiniz
  void _updatePerson(Person person) async {
    final response = await http.put(
      Uri.parse('http://localhost:8081/api/person/${person.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(person.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {
        _personListFuture = fetchPersons(); // Güncellemeden sonra listeyi yenile
      });
    } else {
      // Hata durumunu işleyin
      print('Failed to update person.');
    }
  }
}

class EditPersonPage extends StatefulWidget {
  final Person person;
  final Function(Person) onSave;

  EditPersonPage({required this.person, required this.onSave});

  @override
  _EditPersonPageState createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _customerNoController;
  late TextEditingController _branchNoController;
  late TextEditingController _creditCodeController;
  late TextEditingController _cartonNoController;
  late TextEditingController _creditTypeController;
  late TextEditingController _balanceController;
  late TextEditingController _authorizationCodeController;
  late TextEditingController _statusCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.person.firstName);
    _lastNameController = TextEditingController(text: widget.person.lastName);
    _customerNoController = TextEditingController(text: widget.person.customerNo);
    _branchNoController = TextEditingController(text: widget.person.branchNo);
    _creditCodeController = TextEditingController(text: widget.person.creditCode);
    _cartonNoController = TextEditingController(text: widget.person.cartonNo);
    _creditTypeController = TextEditingController(text: widget.person.creditType);
    _balanceController = TextEditingController(text: widget.person.balance.toString());
    _authorizationCodeController = TextEditingController(text: widget.person.authorizationCode);
    _statusCodeController = TextEditingController(text: widget.person.statusCode);
  }

  void _save() {
    final updatedPerson = Person(
      id: widget.person.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      customerNo: _customerNoController.text,
      branchNo: _branchNoController.text,
      creditCode: _creditCodeController.text,
      cartonNo: _cartonNoController.text,
      creditType: _creditTypeController.text,
      balance: double.parse(_balanceController.text),
      authorizationCode: _authorizationCodeController.text,
      statusCode: _statusCodeController.text,
    );
    widget.onSave(updatedPerson);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _customerNoController,
                decoration: InputDecoration(labelText: 'Customer No'),
              ),
              TextField(
                controller: _branchNoController,
                decoration: InputDecoration(labelText: 'Branch No'),
              ),
              TextField(
                controller: _creditCodeController,
                decoration: InputDecoration(labelText: 'Credit Code'),
              ),
              TextField(
                controller: _cartonNoController,
                decoration: InputDecoration(labelText: 'Carton No'),
              ),
              TextField(
                controller: _creditTypeController,
                decoration: InputDecoration(labelText: 'Credit Type'),
              ),
              TextField(
                controller: _balanceController,
                decoration: InputDecoration(labelText: 'Balance'),
              ),
              TextField(
                controller: _authorizationCodeController,
                decoration: InputDecoration(labelText: 'Authorization Code'),
              ),
              TextField(
                controller: _statusCodeController,
                decoration: InputDecoration(labelText: 'Status Code'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Person {
  final int id;
  final String firstName;
  final String lastName;
  final String customerNo;
  final String branchNo;
  final String creditCode;
  final String cartonNo;
  final String creditType;
  final double balance;
  final String authorizationCode;
  final String statusCode;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.customerNo,
    required this.branchNo,
    required this.creditCode,
    required this.cartonNo,
    required this.creditType,
    required this.balance,
    required this.authorizationCode,
    required this.statusCode,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      customerNo: json['customerNo'],
      branchNo: json['branchNo'],
      creditCode: json['creditCode'],
      cartonNo: json['cartonNo'],
      creditType: json['creditType'],
      balance: json['balance'],
      authorizationCode: json['authorizationCode'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'customerNo': customerNo,
      'branchNo': branchNo,
      'creditCode': creditCode,
      'cartonNo': cartonNo,
      'creditType': creditType,
      'balance': balance,
      'authorizationCode': authorizationCode,
      'statusCode': statusCode,
    };
  }
}
