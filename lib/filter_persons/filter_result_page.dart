
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_color/random_color.dart';

class FilterResultPage extends StatefulWidget {
  final Map<String, String> selectedParameters;

  const FilterResultPage({
    super.key,
    required this.selectedParameters,
  });

  @override
  _FilterResultPageState createState() => _FilterResultPageState();
}

class _FilterResultPageState extends State<FilterResultPage> {
  late Future<List<Person>> _futurePersons;

  @override
  void initState() {
    super.initState();
    _futurePersons = fetchFilteredPersons();
  }

  Future<List<Person>> fetchFilteredPersons() async {
    final queryParams = widget.selectedParameters;
    final uri = Uri.http('localhost:8081', '/api/person/filter', queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return List<Person>.from(jsonResponse.map((model) => Person.fromJson(model)));
    } else {
      print('Failed to load filtered persons. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load filtered persons');
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Result Page'),
        backgroundColor: color,
      ),
      body: FutureBuilder<List<Person>>(
        future: _futurePersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final persons = snapshot.data!;
            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return ListTile(
                  title: Text('${person.firstName} ${person.lastName}'),
                  subtitle: Text('ID: ${person.id}, ${widget.selectedParameters.entries.map((e) => '${e.key}: ${e.value}').join(', ')}'),
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
  final dynamic parameterValue;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.parameterValue,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      parameterValue: json['parameterValue'],
    );
  }
}

