import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/products.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<DocumentSnapshot> group = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController scannerController = TextEditingController();

  PlatformFile? pickedFile;

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

  Future createGroup(String name, String scanner, String image) async {
    try {
      await FirebaseFirestore.instance
          .collection('group')
          .doc()
          .set({'name': name, 'scanner': int.parse(scanner), 'photo': image});
    } catch (e) {
      print(e);
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
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
                      onTap: () async {
                        final path = 'files/${pickedFile!.name}';
                        final file = File(pickedFile!.path!);
                        final ref = FirebaseStorage.instance.ref().child(path);
                        ref.putFile(file);

                        final String imageUrl = await ref.getDownloadURL();

                        createGroup(nameController.text, scannerController.text,
                            imageUrl);
                        getGroup();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Products(),
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
                maxLength: 12,
                controller: scannerController,
                decoration: InputDecoration(
                  labelText: 'Штрих-код',
                ),
                keyboardType: TextInputType.text,
              ),
              // SizedBox(height: 10),
              // Text(
              //   'Цвет папки',
              //   style: TextStyle(fontSize: 20),
              // ),
              // SizedBox(height: 10),
              // Text('Показывать на складах:', style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              selectFile();
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result == null) {
                                pickedFile = result?.files.first;
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Icon(
                                  Icons.image,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
