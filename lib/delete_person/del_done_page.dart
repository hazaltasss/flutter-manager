import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

class DelDonePage extends StatefulWidget {
  final int id;

  const DelDonePage({super.key, required this.id});

  @override
  _DelDonePageState createState() => _DelDonePageState();
}

class _DelDonePageState extends State<DelDonePage> {
  late Future<bool> _futureResult;

  @override
  void initState() {
    super.initState();
    _futureResult = deletePerson(widget.id);
  }

  Future<bool> deletePerson(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:8081/api/person/$id'));

    return response.statusCode == 204;
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Done Page'),
        backgroundColor: color,
      ),
      body: FutureBuilder<bool>(
        future: _futureResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == true) {
            return const Center(child: Text('Person successfully deleted.'));
          } else {
            return const Center(child: Text('Failed to delete person.'));
          }
        },
      ),
    );
  }
}
