import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store/U4etka/Main/products.dart';
import 'package:store/U4etka/Persons/provider.dart';

class NewIncoming extends StatefulWidget {
  const NewIncoming({super.key});

  @override
  State<NewIncoming> createState() => _NewIncomingState();
}

class _NewIncomingState extends State<NewIncoming> {
  DocumentSnapshot? selectedProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        title: Text(
          'Приход новый',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Дата документа',
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(top: 5),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Номер документа',
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.only(top: 5)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final selected = await Navigator.push<DocumentSnapshot>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider(
                              selectMode: true,
                            )));

                if (selected != null) {
                  setState(() {
                    selectedProvider = selected;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Поставщик',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 1),
                    hintStyle: TextStyle(fontSize: 25,color: Colors.black),
                    hintText: selectedProvider != null
                        ? selectedProvider!['name']
                        : null,
                    suffixIcon: selectedProvider == null
                        ? Row(
        children: [
                              Text(
                                'Выберите поставщика',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 20),
                              Icon(
                                Icons.fingerprint_rounded,
                                size: 30,
                                color: Colors.blue,
                              )
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          TextField(
              decoration: InputDecoration(
                  labelText: 'Примечание',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(bottom: 1)),
            )
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        foregroundColor: Colors.white,
        
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Products()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
