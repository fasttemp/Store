import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/add_in_group.dart';

class Group extends StatefulWidget {
  final String groupId;

  const Group({Key? key, required this.groupId}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  late List<DocumentSnapshot> products;

  int index = 0;

  @override
  void initState() {
    super.initState();
    products = [];
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('group')
          .doc(widget.groupId)
          .collection('product')
          .get();
      setState(() {
        products = querySnapshot.docs;
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
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        centerTitle: true,
        title: Text(
          'Группа',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: products.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var productData = products[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: productData['photo'] != null
                        ? Image.network(
                            productData['photo'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image, size: 50),
                    title: Text(productData['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Штрих-код: ${productData['scanner']}'),
                        Text('Описание: ${productData['description']}'),
                        Text('Количество: ${productData['count']}'),
                      ],
                    ),
                    onTap: () {
      
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddInGroup(groupId: widget.groupId),
              ),
            ).then((_) {
              getProducts();
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}