import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Main/add_group.dart';
import 'package:store/U4etka/Main/add_products.dart';

class Products extends StatefulWidget {
  Products({super.key});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  List<DocumentSnapshot> group = [];
  List<DocumentSnapshot> products = [];

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

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    getGroup();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Товары', style: TextStyle(fontSize: 25)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    itemCount: group.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(group[index]['photo'],
                                  width: 100, height: 100),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group[index]['name'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.barcode_reader),
                                      Text(
                                        group[index]['scanner'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ]);
         },),
               Divider(),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(products[index]['photo'],
                                  width: 100, height: 100),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index]['name'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.barcode_reader),
                                      Text(
                                        products[index]['scanner'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    products[index]['description'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    products[index]['count'].toString(),
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  
                ),
                Divider(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //Init Floating Action Bubble
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title: "Добавить Группу",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.group_add,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddGroup()));
                },
              ),
              // Floating action menu item

              Bubble(
                title: "Добавить Товар",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.add_box,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProducts()));
                  _animationController.reverse();
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: Colors.white,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: Colors.blue,
          ),
        ));
  }
}
