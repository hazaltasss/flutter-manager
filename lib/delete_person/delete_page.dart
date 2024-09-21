import 'package:flutter/material.dart';
import 'del_done_page.dart';
import 'package:random_color/random_color.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final TextEditingController _controllerID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Page'),
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
                  labelText: 'Enter ID to delete',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DelDonePage(id: int.parse(_controllerID.text)),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
