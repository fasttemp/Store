import 'package:flutter/material.dart';
import 'package:store/U4etka/main_menu.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int selectedItem = 0;
  List<Widget>widgets = [
  
    MainMenu(),
    Text('Basket'),
    Text('Profile'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: widgets.elementAt(selectedItem)),
      bottomNavigationBar: BottomNavigationBar(items: [BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Главная'),
      BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Люди'),
      BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Настройки')],

      currentIndex: selectedItem,
      selectedIconTheme: IconThemeData(color: Colors.blue),
      selectedItemColor: Colors.blue,
      onTap: (value){
        setState(() {
          selectedItem = value;
        });
      },
      ),
      
      
      );
}
}