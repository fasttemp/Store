import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store/U4etka/Persons/provider.dart';

class AddProvider extends StatefulWidget {
  const AddProvider({super.key});

  @override
  State<AddProvider> createState() => _AddProviderState();
}

class _AddProviderState extends State<AddProvider> {
  List<DocumentSnapshot> provider = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();

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

  Future createProvider(String name, String address, String email, String phone,
      String id, String iban, String footnote) async {
    try {
      await FirebaseFirestore.instance.collection('provider').doc().set({
        'name': name,
        'address': address,
        'email': email,
        'phone': int.parse(phone),
        'id': int.parse(id),
        'iban': iban,
        'footnote': footnote
      });
    } catch (e) {
      print(e);
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
                'Добавить поставщика',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
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
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: addressController,
                  decoration: InputDecoration(
                      labelText: 'Адрес', labelStyle: TextStyle(fontSize: 20)),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Эл.почта',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: 'Телефон',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: idController,
                  decoration: InputDecoration(
                      labelText: 'ИИН', labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: ibanController,
                  decoration: InputDecoration(
                      labelText: 'Банковские реквизиты',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: footnoteController,
                  decoration: InputDecoration(
                      labelText: 'Примечание',
                      labelStyle: TextStyle(fontSize: 20)),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(210, 15, 145, 185)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          idController.text.isEmpty ||
                          ibanController.text.isEmpty ||
                          footnoteController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color.fromARGB(210, 15, 145, 185),
                          content: Center(
                            child: Text(
                              'Заполните все поля !!!',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ));
                        return;
                      } else {
                        createProvider(
                            nameController.text,
                            addressController.text,
                            emailController.text,
                            phoneController.text,
                            idController.text,
                            ibanController.text,
                            footnoteController.text);
                        getProvider();
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Добавить',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
