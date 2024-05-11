import 'package:flutter/material.dart';
import 'package:store/U4etka/products.dart';

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
          'Главное Меню',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
      ),
      
      body: Column(
      
        children: [
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => Products(name: '', scanner: '',)));
                  },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(20),
                            color: Colors.blue),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_box),
                            Text('Товары',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            Text(
                              '0',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.blue),
                      height: 100,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_document),
                          Text('Документы',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.blue),
                      height: 100,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.graphic_eq_outlined),
                          Text('Отчёты',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      )),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.blue),
                      height: 100,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.money_off),
                          Text('Затраты',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.blue),
                      height: 100,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.plus_one),
                          Text('Новый Приход',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      )),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.blue),
                      height: 100,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exposure_minus_1),
                          Text('Новый Расход',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

