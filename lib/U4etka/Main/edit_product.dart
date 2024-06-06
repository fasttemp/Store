import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:store/U4etka/Main/products.dart';

class EditProduct extends StatefulWidget {
  final DocumentSnapshot product;

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  List<DocumentSnapshot> products = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController scannerController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController countController = TextEditingController();

  PlatformFile? pickedFile;
  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    scannerController =
        TextEditingController(text: widget.product['scanner'].toString());
    descripController =
        TextEditingController(text: widget.product['description']);
    countController =
        TextEditingController(text: widget.product['count'].toString());
    uploadedImageUrl = widget.product['photo'];
  }

  @override
  void dispose() {
    nameController.dispose();
    scannerController.dispose();
    descripController.dispose();
    countController.dispose();
    super.dispose();
  }

  Future<void> getUpdate(String name, String scanner, String description,
      String count, String? photoUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
        'name': name,
        'scanner': int.parse(scanner),
        'description': description,
        'count': int.parse(count),
        'photo': photoUrl,
      });
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      Navigator.pop(context, false);
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

  Future<void> deleteFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
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
              if (uploadedImageUrl != null) {
                await deleteFile(uploadedImageUrl!);
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.product.id)
                    .update({'photo': FieldValue.delete()});
                setState(() {
                  uploadedImageUrl = null;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  Widget displayImage(String? imageUrl) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            )
          : Icon(
              Icons.image,
              size: 50,
              color: Colors.grey,
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
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          centerTitle: true,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Редактировать',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              SizedBox(width: 30),
              InkWell(
                  onTap: () async {
                    String? imageUrl = uploadedImageUrl;
                    if (pickedFile != null) {
                      imageUrl = await uploadFile(pickedFile!);
                    }

                    await getUpdate(
                      nameController.text,
                      scannerController.text,
                      descripController.text,
                      countController.text,
                      imageUrl,
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Products(),
                        ));
                  },
                  child: Icon(
                    Icons.check_circle,
                    size: 45,
                    color: Colors.white,
                  ))
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
                      labelText: 'Наименование',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 25),
                        controller: scannerController,
                        decoration: InputDecoration(
                            labelText: 'Штрих-код',
                            labelStyle: TextStyle(fontSize: 20)),
                        keyboardType: TextInputType.text,
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
                      labelText: 'Описание',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: countController,
                  decoration: InputDecoration(
                      labelText: 'Количество',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
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
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          showDeleteDialog(context);
                        },
                        child: displayImage(uploadedImageUrl),
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
