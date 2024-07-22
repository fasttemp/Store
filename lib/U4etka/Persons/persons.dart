import 'package:flutter/cupertino.dart';
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
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        title: Text(
          'Контрагенты',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Provider()));
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(210, 5, 53, 67).withOpacity(0.2),
                          offset: Offset(0, 5),
                        )
                      ],
                      borderRadius: BorderRadiusDirectional.circular(50),
                      color: Color.fromARGB(210, 15, 145, 185),
                    ),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_2_outlined,
                            size: 30, color: Colors.white),
                        Text('Поставщики',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ],
                    )),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Buyers()));
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(210, 5, 53, 67).withOpacity(0.2),
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadiusDirectional.circular(50),
                      color: Color.fromARGB(210, 15, 145, 185),
                    ),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text('Покупатели',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
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
