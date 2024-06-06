import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/main_menu.dart';
import 'package:store/U4etka/Settings/settings_page.dart';
import 'package:store/U4etka/Persons/persons.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int selectedItem = 0;
  List<Widget>widgets = [
  
    MainMenu(),
    Persons(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: widgets.elementAt(selectedItem)),
      bottomNavigationBar: BottomNavigationBar(items: [BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Главная'),
      BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Люди'),
      BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Настройки')],
             backgroundColor: Color.fromARGB(210, 15, 145, 185),
      currentIndex: selectedItem,
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedItemColor: Colors.white,
      onTap: (value){
        setState(() {
          selectedItem = value;
        });
      },
      ),
      
      
      );
}
}