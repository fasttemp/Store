import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/costs.dart';
import 'package:store/U4etka/Main/documents.dart';
import 'package:store/U4etka/Main/expenses.dart';
import 'package:store/U4etka/Main/new_incoming.dart';
import 'package:store/U4etka/Main/products.dart';
import 'package:store/U4etka/Main/reports.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'U4ETKA',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
      ),
      body: Column(
        children: [
          SizedBox(height: 130),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Products()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box,
                              size: 25,
                              color: Colors.white,
                            ),
                            Text('Товары',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ],
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Documents()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_document,
                              size: 25,
                              color: Colors.white,
                            ),
                            Text('Документы',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Reports()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.graphic_eq_outlined,
                                size: 25, color: Colors.white),
                            Text('Отчёты',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ],
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Expenses()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.money_off,
                                size: 25, color: Colors.white),
                            Text('Затраты',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewIncoming()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text('Приход',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            
                          ],
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Costs()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Color.fromARGB(210, 15, 145, 185),
                        ),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text('Расход',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
