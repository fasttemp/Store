import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/products.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<DocumentSnapshot> products = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController scannerController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController countController = TextEditingController();

  PlatformFile? pickedFile;

  Future getProducts() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('products').get();

      setState(() {
        products = collection.docs;
      });
    } catch (e) {
      print(e);
    }
  }

  Future createProducts(String name, String scanner, String image,
      String description, String count) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc().set({
        'name': name,
        'scanner': int.parse(scanner),
        'photo': image,
        'description': description,
        'count': int.parse(count)
      });
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
                'Добавление товара',
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

                        createProducts(
                            nameController.text,
                            scannerController.text,
                            imageUrl,
                            descripController.text,
                            countController.text);
                        getProducts();

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
                //maxLength: 12,
                controller: scannerController,
                decoration: InputDecoration(
                  labelText: 'Штрих-код',
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: descripController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: countController,
                decoration: InputDecoration(
                  labelText: 'Количество',
                ),
                keyboardType: TextInputType.number,
              ),
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
