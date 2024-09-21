import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_color/random_color.dart';

import 'search_person/search_page.dart';
import 'list_persons/list_page.dart';
import 'create_person/create_page.dart';
import 'delete_person/delete_page.dart';
import 'filter_persons/filter_page.dart';
import 'credit_dashboard/credit_dashboard_page.dart';
import 'intikal_page/intikal_page.dart';
import 'update_page/update_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchURL() async {
    const url = 'https://softtech.com.tr/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor(colorHue: ColorHue.purple);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: color,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _launchURL,
                child: Image.asset('assets/softtech-photo.png', height: 150),
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Go to Search Page',
                SearchPage(),
              ),
              _buildMenuButton(
                context,
                'Go to List Page',
                ListPage(),
              ),
              _buildMenuButton(
                context,
                'Go to Create Page',
                CreatePage(),
              ),
              _buildMenuButton(
                context,
                'Go to Delete Page',
                DeletePage(),
              ),
              _buildMenuButton(
                context,
                'Go to Filter Page',
                FilterPage(),
              ),
              _buildMenuButton(
                context,
                'Go to Update Page',
                UpdatePage(),
              ),
              _buildMenuButton(
                context,
                'Go to Intikal Page',
                IntikalPage(),
              ),
              _buildMenuButton(
                context,
                'Go to Dashboard Page',
                CreditDashboardPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
