import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IntikalPage extends StatefulWidget {
  @override
  _IntikalPageState createState() => _IntikalPageState();
}

class _IntikalPageState extends State<IntikalPage> {
  late Future<int> _intikalCount;
  late Future<List<Person>> _intikalList;

  @override
  void initState() {
    super.initState();
    _intikalCount = fetchIntikalCountForToday();
    _intikalList = fetchIntikalListForToday();
  }

  Future<int> fetchIntikalCountForToday() async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/person/intikal-sayisi'));

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('İntikal sayısı alınamadı');
    }
  }

  Future<List<Person>> fetchIntikalListForToday() async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/person/intikal-listesi'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => Person.fromJson(item)).toList();
    } else {
      throw Exception('İntikal listesi alınamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İntikal Sayısı ve Listesi'),
      ),
      body: Column(
        children: [
          FutureBuilder<int>(
            future: _intikalCount,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hata: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('İntikal sayısı bulunamadı.'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Bugün için toplam intikal sayısı: ${snapshot.data}'),
                );
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<Person>>(
              future: _intikalList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Bugün için intikal bulunamadı.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final person = snapshot.data![index];
                      return ListTile(
                        title: Text('${person.firstName} ${person.lastName}'),
                        subtitle: Text('Müşteri No: ${person.customerNo}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Person {
  final int id;
  final String firstName;
  final String lastName;
  final String customerNo;
  final String creditType;
  final double balance;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.customerNo,
    required this.creditType,
    required this.balance,

  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      customerNo: json['customerNo'],
      creditType: json['creditType'],
      balance: json['balance'],
    );
  }
}