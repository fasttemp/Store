import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03dac6),
        centerTitle: true,
        title: Text('Отчёты',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),

      body: ListView(),
    );
  }
}
