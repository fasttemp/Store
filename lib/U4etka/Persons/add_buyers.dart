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

  Future getProvider() async {
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
          centerTitle: true,
          title: Row(
            children: [
              Text(
                'Добавить покупателя',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: InkWell(
                child: Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Color.fromARGB(255, 23, 136, 33),
                ),
                onTap: () {
                  createBuyers(
                      nameController.text,
                      addressController.text,
                      emailController.text,
                      phoneController.text,
                      idController.text,
                      ibanController.text,
                      footnoteController.text);

                    getProvider();
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Buyers()));
                },
              ))
            ],
          ),
        ),

      body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Наименование',
                      labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.w500)),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Адрес',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Эл.почта',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Телефон',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'ИИН',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ibanController,
                  decoration: InputDecoration(
                    labelText: 'Банковские реквизиты',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: footnoteController,
                  decoration: InputDecoration(
                    labelText: 'Примечание',
                    floatingLabelStyle: TextStyle(color: Colors.green),
                  ),
                  keyboardType: TextInputType.text,
                  
                ),
              ],
            ),
          ),
        )); 
  }
}