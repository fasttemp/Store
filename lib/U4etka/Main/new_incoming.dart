import 'package:flutter/material.dart';

class NewIncoming extends StatefulWidget {
  const NewIncoming({super.key});

  @override
  State<NewIncoming> createState() => _NewIncomingState();
}

class _NewIncomingState extends State<NewIncoming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03dac6),
        title: Text(
          'Приход новый',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(prefixText: 'dvdvvdvd'),
          ),
        ],
      ),
    );
  }
}
