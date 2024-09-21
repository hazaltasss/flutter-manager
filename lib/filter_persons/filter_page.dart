
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'filter_result_page.dart';
import 'package:random_color/random_color.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> _parameters = [
    'Customer No',
    'Branch No',
    'Credit Code',
    'Carton No',
    'Credit Type',
    'Min Balance',
    'Max Balance',
    'Authorization Code',
    'Status Code'
  ];
  final Map<String, String> _selectedParameters = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var param in _parameters) {
      _controllers[param] = TextEditingController();
    }
  }

  Future<void> _filterPersons() async {
    final queryParams = <String, String>{};
    _selectedParameters.forEach((key, value) {
      queryParams[key] = value;
    });

    final uri = Uri.http('localhost:8081', '/api/person/filter', queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterResultPage(
              selectedParameters: _selectedParameters,
            ),
          ),
        );
      } else {
        print('Failed to load filtered persons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Page'),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _parameters.map((param) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(param),
                      TextField(
                        controller: _controllers[param],
                        decoration: InputDecoration(
                          labelText: 'Enter value for $param',
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              _selectedParameters[param] = value;
                            } else {
                              _selectedParameters.remove(param);
                            }
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _filterPersons,
              child: const Text('Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
