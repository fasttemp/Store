import 'package:flutter/material.dart';
import 'income_report.dart';
import 'cost_report.dart';
import 'expense_report.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: Text('Отчеты',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Приход',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IncomeReport()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Расход',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CostReport()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Затраты',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseReport()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
