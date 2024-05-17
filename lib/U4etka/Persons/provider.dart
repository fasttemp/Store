import 'dart:async';
import 'dart:js_interop_unsafe';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:store/U4etka/Persons/add_provider.dart';

class Provider extends StatefulWidget {

  const Provider({
    super.key,
    
  });

  @override
  State<Provider> createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  List<DocumentSnapshot> provider = [];

  @override
  void initState() {
    super.initState();
    getProvider();
  }

  Future getProvider() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('provider').get();
      setState(() {
        provider = collection.docs;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03dac6),
        title: Row(
          children: [
            Text('Поставщики',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(width: 20),
            Icon(Icons.search, size: 35)
          ],
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(indent: 500, height: 1),
        itemCount: provider.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      provider[index]['name'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        size: 30,
                      ),
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('provider')
                            .doc()
                            .delete();

                      },
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProvider()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
