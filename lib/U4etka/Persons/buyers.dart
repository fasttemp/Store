import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Persons/add_buyers.dart';

class Buyers extends StatefulWidget {
  const Buyers({super.key});

  @override
  State<Buyers> createState() => _BuyersState();
}

class _BuyersState extends State<Buyers> {
  List<DocumentSnapshot> buyers = [];

  @override
  void initState() {
    super.initState();
    getBuyers();
  }

  Future getBuyers() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('buyers').get();
      setState(() {
        buyers = collection.docs;
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
            Text('Покупатели',
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
        separatorBuilder: (context, index) => Divider(indent: 500,height: 1,),
        itemCount: buyers.length,
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
                      buyers[index]['name'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        size: 30,
                      ),
                      onTap: () {},
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
              context, MaterialPageRoute(builder: (context) => AddBuyers()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
