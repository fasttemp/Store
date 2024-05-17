import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store/U4etka/Persons/buyers.dart';
import 'package:store/U4etka/Persons/provider.dart';

class Persons extends StatefulWidget {
  const Persons({super.key});

  @override
  State<Persons> createState() => _PersonsState();
}

class _PersonsState extends State<Persons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Контрагенты',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Provider()));
                },
                child: Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(50),
                        color: Colors.blue),
                    height: 100,
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_2_outlined),
                        Text('Поставщики',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    )),
              ),
            ),
            SizedBox(height: 40),
             Expanded(
              child: InkWell(
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => Buyers()));
                   },
                child: Container(
                   width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(50),
                        color: Colors.blue),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_2_outlined),
                        Text('Покупатели',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
