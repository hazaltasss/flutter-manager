import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_color/random_color.dart';

class DonePage extends StatefulWidget {
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
  final DateTime intikalDate;

  const DonePage({
    super.key,
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
    required this.intikalDate,
  });

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  late Future<bool> _futurePerson;

  @override
  void initState() {
    super.initState();
    _futurePerson = createPerson();
  }

  Future<bool> createPerson() async {
    final response = await http.post(
      Uri.parse('http://localhost:8081/api/person/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': widget.id,
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'customerNo': widget.customerNo,
        'branchNo': widget.branchNo,
        'creditCode': widget.creditCode,
        'cartonNo': widget.cartonNo,
        'creditType': widget.creditType,
        'balance': widget.balance,
        'authorizationCode': widget.authorizationCode,
        'statusCode': widget.statusCode,
      }),
    );

    return response.statusCode == 201;
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Page'),
        backgroundColor: color,
      ),
      body: FutureBuilder<bool>(
        future: _futurePerson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == true) {
            return const Center(child: Text('Person successfully created.'));
          } else {
            return const Center(child: Text('Failed to create person.'));
          }
        },
      ),
    );
  }
}
