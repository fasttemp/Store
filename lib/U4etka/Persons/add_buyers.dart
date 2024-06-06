import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Persons/buyers.dart';

class AddBuyers extends StatefulWidget {
  const AddBuyers({super.key});

  @override
  State<AddBuyers> createState() => _AddBuyersState();
}

class _AddBuyersState extends State<AddBuyers> {
  List<DocumentSnapshot> buyers = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();

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

  Future createBuyers(String name, String address, String email, String phone,
      String id, String iban, String footnote) async {
    try {
      await FirebaseFirestore.instance.collection('buyers').doc().set({
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
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
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
          centerTitle: true,
          title: Row(
            children: [
              Text(
                'Добавить покупателя',
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
                  style: TextStyle(fontSize: 20),
                  controller: nameController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'Наименование',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      )),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: addressController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'Адрес',
                      labelStyle: TextStyle(fontSize: 20)),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: emailController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'Эл.почта',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: phoneController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'Телефон',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: idController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'ИИН',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: ibanController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
                      labelText: 'Банковские реквизиты',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  controller: footnoteController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(210, 15, 145, 185))),
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
                        createBuyers(
                            nameController.text,
                            addressController.text,
                            emailController.text,
                            phoneController.text,
                            idController.text,
                            ibanController.text,
                            footnoteController.text);

                        getBuyers();
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
