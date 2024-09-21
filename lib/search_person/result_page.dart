import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_color/random_color.dart';
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget {
  final String id;

  const ResultPage({super.key, required this.id});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<Person> _futurePerson;

  @override
  void initState() {
    super.initState();
    _futurePerson = fetchPerson(widget.id);
  }

  Future<Person> fetchPerson(String id) async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/person/$id'));

    if (response.statusCode == 200) {
      // UTF-8 çözümlemesi yapıyoruz
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return Person.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load person');
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
        backgroundColor: color,
      ),
      body: FutureBuilder<Person>(
        future: _futurePerson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final person = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${person.id}'),
                  Text('First Name: ${person.firstName}'),
                  Text('Last Name: ${person.lastName}'),
                  Text('Customer No: ${person.customerNo}'),
                  Text('Branch No: ${person.branchNo}'),
                  Text('Credit Code: ${person.creditCode}'),
                  Text('Carton No: ${person.cartonNo}'),
                  Text('Credit Type: ${person.creditType}'),
                  Text('Balance: ${person.balance}'),
                  Text('Authorization Code: ${person.authorizationCode}'),
                  Text('Status Code: ${person.statusCode}'),
                  Text('Intikal Date: ${DateFormat.yMd().format(person.intikalDate)}'),
                ],
              ),
            );
          }
        },
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
  final DateTime intikalDate;

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
    required this.intikalDate,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'] is String
          ? json['firstName']
          : (json['firstName'] as List<dynamic>)[0],
      lastName: json['lastName'] is String
          ? json['lastName']
          : (json['lastName'] as List<dynamic>)[0],
      customerNo: json['customerNo'] as String,
      branchNo: json['branchNo'] as String,
      creditCode: json['creditCode'] as String,
      cartonNo: json['cartonNo'] as String,
      creditType: json['creditType'] as String,
      balance: json['balance'] is double
          ? json['balance']
          : (json['balance'] as num).toDouble(),  
      authorizationCode: json['authorizationCode'] as String,
      statusCode: json['statusCode'] as String,
      intikalDate: json['intikalDate'] != null
          ? DateTime.parse(json['intikalDate'])
          : DateTime.now(),
    );
  }
}
