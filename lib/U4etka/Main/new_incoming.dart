import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:store/U4etka/Main/products.dart';
import 'package:store/U4etka/Persons/provider.dart';

class NewIncoming extends StatefulWidget {
  const NewIncoming({super.key});

  @override
  State<NewIncoming> createState() => _NewIncomingState();
}

class _NewIncomingState extends State<NewIncoming> {
  DocumentSnapshot? selectedProvider;
  List<DocumentSnapshot> selectedProducts = [];
  TextEditingController dataController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataController.text = formatDate(DateTime.now());
  }

  Future createIncome(
      String data, String id, String title, String description) async {
    try {
      await FirebaseFirestore.instance.collection('income').doc().set({
        'data': data,
        'id': int.parse(id),
        'title': title,
        'description': description,
        'products': selectedProducts.map((product) {
          return {
            'name': product['name'],
            'scanner': product['scanner'],
            'description': product['description'],
            'count': product['count'],
            'photo': product['photo'],
          };
        }).toList(),
      });
    } catch (e) {
      print(e);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy', 'ru').format(date);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ru', 'RU'),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dataController.text = formatDate(pickedDate);
      });
    }
  }

  Widget displayImage(String? imageUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            )
          : Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ),
            ),
    );
  }

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
        centerTitle: true,
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        title: Row(
          children: [
            Text(
              'Приход',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(width: 100),
            Expanded(
                child: InkWell(
              onTap: () async {
                if (dataController.text.isEmpty ||
                    idController.text.isEmpty ||
                    descController.text.isEmpty ||
                    selectedProvider == null ||
                    selectedProducts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: Color.fromARGB(210, 15, 145, 185),
                    content: Text(
                      'Заполните все поля и выберите поставщика и продукты',
                      style: TextStyle(fontSize: 18),
                    ),
                  ));
                  return;
                }

                await createIncome(dataController.text, idController.text,
                    selectedProvider?['name'] ?? '', descController.text);

                Navigator.pop(context);
              },
              child: Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.white,
              ),
            ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dataController,
                        decoration: InputDecoration(
                          labelText: 'Дата документа',
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(top: 5),
                        ),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'Номер документа',
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(top: 5),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final selected = await Navigator.push<DocumentSnapshot>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Provider(selectMode: true),
                  ),
                );

                if (selected != null) {
                  setState(() {
                    selectedProvider = selected;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Поставщик',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 1),
                    hintStyle: TextStyle(fontSize: 25, color: Colors.black),
                    hintText: selectedProvider != null
                        ? selectedProvider!['name']
                        : null,
                    suffixIcon: selectedProvider == null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Выберите поставщика',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.fingerprint,
                                size: 30,
                                color: Color.fromARGB(210, 15, 145, 185),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Примечание',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.only(bottom: 1),
              ),
              maxLines: null,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = selectedProducts[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            displayImage(product['photo']),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.barcode_reader),
                                      SizedBox(width: 5),
                                      Text(
                                        product['scanner'].toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        product['description'],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Spacer(),
                                      Text(
                                        product['count'].toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        foregroundColor: Colors.white,
        onPressed: () async {
          final selected = await Navigator.push<DocumentSnapshot>(
            context,
            MaterialPageRoute(builder: (context) => Products(selectMode: true)),
          );

          if (selected != null &&
              !selectedProducts.any((product) => product.id == selected.id)) {
            setState(() {
              selectedProducts.add(selected);
            });
          } else if (selected != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Товар уже добавлен',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              backgroundColor: Color.fromARGB(210, 15, 145, 185),
              duration: Duration(seconds: 2),
            ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
