import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProvider extends StatefulWidget {
  final DocumentSnapshot provider;

  const EditProvider({super.key, required this.provider});

  @override
  State<EditProvider> createState() => _EditProviderState();
}

class _EditProviderState extends State<EditProvider> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController footnoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.provider['name']);
    addressController = TextEditingController(text: widget.provider['address']);
    emailController = TextEditingController(text: widget.provider['email']);
    phoneController =
        TextEditingController(text: widget.provider['phone'].toString());
    idController =
        TextEditingController(text: widget.provider['id'].toString());
    ibanController = TextEditingController(text: widget.provider['iban']);
    footnoteController =
        TextEditingController(text: widget.provider['footnote']);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idController.dispose();
    ibanController.dispose();
    footnoteController.dispose();
  }

  Future<void> updateProvider(String name, String address, String email,
      String phone, String id, String iban, String footnote) async {
    try {
      await FirebaseFirestore.instance
          .collection('provider')
          .doc(widget.provider.id)
          .update({
        'name': name,
        'address': address,
        'email': email,
        'phone': int.parse(phone),
        'id': int.parse(id),
        'iban': iban,
        'footnote': footnote,
      });
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap:(){
              Navigator.pop(context);
          },
            child:
                Icon(Icons.arrow_back_ios_new, size: 25, color: Colors.white)),
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        centerTitle: true,
        title: Text(
          'Поставщик',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'Наименование',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: addressController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'Адрес',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: emailController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'Эл.почта',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'Телефон',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: idController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'ИИН',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ibanController,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  labelText: 'Банковские реквизиты',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: footnoteController,
                style: TextStyle(fontSize: 25),
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Примечание',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
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
                  onPressed: () {
                    updateProvider(
                      nameController.text,
                      addressController.text,
                      emailController.text,
                      phoneController.text,
                      idController.text,
                      ibanController.text,
                      footnoteController.text,
                    );
                  },
                  child: Text(
                    'Обновить',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
