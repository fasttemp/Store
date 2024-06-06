import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddInGroup extends StatefulWidget {
  final String groupId;

  const AddInGroup({required this.groupId, Key? key}) : super(key: key);

  @override
  State<AddInGroup> createState() => _AddInGroupState();
}

class _AddInGroupState extends State<AddInGroup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController scannerController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController countController = TextEditingController();

  PlatformFile? pickedFile;
  String? uploadedImageUrl;

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

  Future<void> createProduct(String groupId, String name, String scanner,
      String image, String description, String count) async {
    try {
      // Добавляем товар в подколлекцию products для соответствующей группы
      DocumentReference productRef = await FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .collection('product')
          .add({
        'name': name,
        'scanner': int.parse(scanner),
        'photo': image,
        'description': description,
        'count': int.parse(count)
      });

      // Получаем добавленный товар с его ID
      DocumentSnapshot newProduct = await productRef.get();

      // Возвращаем добавленный товар в предыдущий экран
      Navigator.pop(context, newProduct);
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
        title: Text(
          'Добавление товара',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
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
                      padding: const EdgeInsets.symmetric(horizontal: 120),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(210, 15, 145, 185),
                          ),
                          onPressed: () async {
                            await selectFile();
                            if (pickedFile != null) {
                              final imageUrl = await uploadFile(pickedFile!);
                              setState(() {
                                uploadedImageUrl = imageUrl;
                              });
                            }
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
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (uploadedImageUrl != null)
                      InkWell(
                        onTap: () {
                          showDeleteDialog(context);
                        },
                        child: Image.network(
                          uploadedImageUrl!,
                          width: 100,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(210, 15, 145, 185),
                    ),
                    onPressed: () async {
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

                      await createProduct(
                        widget.groupId,
                        nameController.text,
                        scannerController.text,
                        uploadedImageUrl ?? '',
                        descripController.text,
                        countController.text,
                      );
                    },
                    child: Text(
                      'Добавить',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
