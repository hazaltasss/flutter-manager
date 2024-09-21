import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_color/random_color.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Person>> _futurePersons;

  @override
  void initState() {
    super.initState();
    _futurePersons = fetchPersons();
  }

  Future<List<Person>> fetchPersons() async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/person/'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return List<Person>.from(jsonResponse.map((model) => Person.fromJson(model)));
    } else {
      throw Exception('Failed to load persons');
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
        backgroundColor: color,
      ),
      body: FutureBuilder<List<Person>>(
        future: _futurePersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final persons = snapshot.data!;
            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return ListTile(
                  title: Text('${person.firstName} ${person.lastName}'),
                  subtitle: Text('ID: ${person.id}'),
                );
              },
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

  Person({required this.id, required this.firstName, required this.lastName});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
