import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<DocumentSnapshot> expenses = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController sumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = formatDate(DateTime.now());
    getExpenses();
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
        dateController.text = formatDate(pickedDate);
      });
    }
  }

  Future getExpenses() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('expenses').get();
      setState(() {
        expenses = collection.docs;
      });
    } catch (error) {
      print(error);
    }
  }

  Future createExpenses(String title, String date, String sum) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc()
        .set({'title': title, 'date': date, 'sum': int.parse(sum)});

    await getExpenses();
  }

  Future updateExpenses(String expensesId, String title, String date, String sum) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(expensesId)
        .update({'title': title, 'date': date, 'sum': int.parse(sum)});
    await getExpenses();
  }

  Future deleteExpenses(String expensesId) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(expensesId)
        .delete();
    await getExpenses();
  }

  void showDeleteDialog(String expensesId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          content: Text('Вы уверены, что хотите удалить этот элемент?',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ОТМЕНА', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                deleteExpenses(expensesId);
                Navigator.pop(context);
              },
              child: Text('УДАЛИТЬ', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showOptionsDialog(String expensesId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          content: TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDeleteDialog(expensesId);
            },
            child: Text(
              'Удалить',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void showExpenseDialog({String? expensesId, String? title, String? date, String? sum}) {
    if (title != null) titleController.text = title;
    if (date != null) dateController.text = date;
    if (sum != null) sumController.text = sum;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(210, 15, 145, 185),
            title: Center(
              child: Text(
                expensesId == null ? 'Добавление затрат' : 'Редактирование затрат',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: <Widget>[
              Container(
                width: 300,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Builder(builder: (context) {
                          return Expanded(
                            child: InkWell(
                              onTap: () => selectDate(context),
                              child: AbsorbPointer(
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white)),
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white)),
                                    labelText: 'Дата',
                                    labelStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 1),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                            controller: sumController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white)),
                              labelText: 'Сумма',
                              labelStyle: TextStyle(
                                  fontSize: 17, color: Colors.black),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.only(bottom: 1),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      controller: titleController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Наименование',
                        labelStyle:
                            TextStyle(fontSize: 17, color: Colors.black),
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.only(bottom: 1),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('ОТМЕНА',
                                style: TextStyle(color: Colors.white))),
                        SizedBox(width: 20),
                        TextButton(
                            onPressed: () {
                              if (expensesId == null) {
                                createExpenses(
                                    titleController.text,
                                    dateController.text,
                                    sumController.text);
                              } else {
                                updateExpenses(
                                    expensesId,
                                    titleController.text,
                                    dateController.text,
                                    sumController.text);
                              }
                              Navigator.pop(context);
                            },
                            child: Text('OK',
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined,
              size: 25, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        centerTitle: true,
        title: Text(
          'Затраты',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                showExpenseDialog(
                  expensesId: expenses[index].id,
                  title: expenses[index]['title'],
                  date: expenses[index]['date'],
                  sum: expenses[index]['sum'].toString(),
                );
              },
              onLongPress: () {
                showOptionsDialog(expenses[index].id);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(expenses[index]['title'],
                            style: TextStyle(fontSize: 18)),
                        Text( '${expenses[index]['sum'].toString()} ₸',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Text(expenses[index]['date'],
                        style: TextStyle(fontSize: 18)),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        foregroundColor: Colors.white,
        onPressed: () {
          titleController.clear();
          dateController.text = formatDate(DateTime.now());
          sumController.clear();
          showExpenseDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
