import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/products.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  String? uploadedImageUrl;

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

  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final path = 'files/${file.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(File(file.path!));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteFile(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print(e);
    }
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить изображение'),
        content: Text('Вы уверены, что хотите удалить изображение?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              await deleteFile(uploadedImageUrl!);
              setState(() {
                pickedFile = null;
                uploadedImageUrl = null;
              });
              Navigator.of(context).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  Future<void> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Отменить", true, ScanMode.BARCODE);

      if (barcodeScanRes != "-1") {
        setState(() {
          scannerController.text = barcodeScanRes;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new,
                  size: 25, color: Colors.white)),
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          centerTitle: true,
          title: Row(
            children: [
              Text(
                'Добавление товара',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(width: 30),
              Expanded(
                  child: InkWell(
                      onTap: () async {
                        if (nameController.text.isEmpty ||
                            scannerController.text.isEmpty ||
                            descripController.text.isEmpty ||
                            countController.text.isEmpty ||
                            pickedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Color.fromARGB(210, 15, 145, 185),
                            content: Text(
                              'Заполните все поля и выберите файл',
                              style: TextStyle(fontSize: 18),
                            ),
                          ));
                          return;
                        }

                        final imageUrl = await uploadFile(pickedFile!);
                        if (imageUrl != null) {
                          await createProducts(
                              nameController.text,
                              scannerController.text,
                              imageUrl,
                              descripController.text,
                              countController.text);
                          await getProducts();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Не удалось загрузить файл'),
                          ));
                        }
                      },
                      child: Icon(
                        Icons.check_circle,
                        size: 45,
                        color: Colors.white,
                      )))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Наименование',labelStyle: TextStyle(fontSize: 20)
                  ),
                  keyboardType: TextInputType.text,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 25),
                        controller: scannerController,
                        decoration: InputDecoration(
                          labelText: 'Штрих-код',labelStyle: TextStyle(fontSize: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.barcode_reader),
                      onPressed: scanBarcode,
                    ),
                  ],
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: descripController,
                  decoration: InputDecoration(
                    labelText: 'Описание',labelStyle: TextStyle(fontSize: 20)
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: countController,
                  decoration: InputDecoration(
                    labelText: 'Количество',labelStyle: TextStyle(fontSize: 20)
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 120),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(210, 15, 145, 185),
                              ),
                              onPressed: () async {
                                await selectFile();
                                if (pickedFile != null) {
                                  final imageUrl =
                                      await uploadFile(pickedFile!);
                                  setState(() {
                                    uploadedImageUrl = imageUrl;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white),
                                  Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (uploadedImageUrl != null)
                        InkWell(
                          onTap: () {
                            showDeleteDialog(context);
                          },
                          child: Image.network(
                            uploadedImageUrl!,
                            width: 100,
                            height: 100,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
