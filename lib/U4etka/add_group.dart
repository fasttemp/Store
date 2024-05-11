import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/products.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<DocumentSnapshot> group = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController scannerController = TextEditingController();

  get index => null;
  @override
  void initState() {
    super.initState();
    getGroup();
  }

  Future getGroup() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('group').get();

      setState(() {
        group = collection.docs;
      });
    } catch (e) {
      print(e);
    }
  }

  Future createGroup(String name, String scanner) async {
    try {
      await FirebaseFirestore.instance
          .collection('group')
          .doc()
          .set({'name': name, 'scanner': int.parse(scanner)});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Text(
                'Добавление группы',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 40),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        createGroup(
                            nameController.text, scannerController.text);
                        getGroup();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Products(
                                name: group[index]['name'],
                                scanner: group[index]['scanner'],
                              ),
                            ));
                      },
                      child: Icon(Icons.check_circle, size: 35)))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Наименование',
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: scannerController,
                decoration: InputDecoration(
                  labelText: 'Штрих-код',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              Text(
                'Цвет папки',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text('Показывать на складах:', style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.photo_camera,
                        )),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.image,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
