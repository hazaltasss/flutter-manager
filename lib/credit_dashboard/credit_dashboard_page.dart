import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class CreditDashboardPage extends StatefulWidget {
  @override
  _CreditDashboardPageState createState() => _CreditDashboardPageState();
}

class _CreditDashboardPageState extends State<CreditDashboardPage> {
  late Future<List<Person>> _intikalList;

  @override
  void initState() {
    super.initState();
    _intikalList = fetchIntikalListForToday();
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


  Map<String, Map<String, dynamic>> calculateTotalBalanceAndCountByCreditType(List<Person> intikalList) {
    Map<String, Map<String, dynamic>> balanceAndCountByCreditType = {};

    for (var person in intikalList) {
      if (balanceAndCountByCreditType.containsKey(person.creditType)) {
        balanceAndCountByCreditType[person.creditType]!['totalBalance'] += person.balance;
        balanceAndCountByCreditType[person.creditType]!['count'] += 1;
      } else {
        balanceAndCountByCreditType[person.creditType] = {
          'totalBalance': person.balance,
          'count': 1,
        };
      }
    }

    return balanceAndCountByCreditType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kredi Dashboard'),
      ),
      body: FutureBuilder<List<Person>>(
        future: _intikalList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Bugün için intikal bulunamadı.'));
          } else {

            Map<String, Map<String, dynamic>> balanceAndCountByCreditType = calculateTotalBalanceAndCountByCreditType(snapshot.data!);

            int totalCount = balanceAndCountByCreditType.values.fold<int>(
                0,
                    (int sum, item) => sum + item['count'] as int
            );
            double totalBalance = balanceAndCountByCreditType.values.fold<double>(
                0.0,
                    (double sum, item) => sum + (item['totalBalance'] as double)
            );


            return Center(
              child: SfCircularChart(
                title: ChartTitle(text: 'Kredi Tipine Göre Toplam Bakiye ve Kişi Sayısı'),
                legend: Legend(isVisible: true),
                series: <PieSeries>[
                  PieSeries<MapEntry<String, Map<String, dynamic>>, String>(
                    dataSource: balanceAndCountByCreditType.entries.toList(),
                    xValueMapper: (MapEntry<String, Map<String, dynamic>> data, _) => '${data.key} (${data.value['count']} kişi)',
                    yValueMapper: (MapEntry<String, Map<String, dynamic>> data, _) => data.value['totalBalance'],
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
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
