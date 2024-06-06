import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store/U4etka/Main/add_group.dart';
import 'package:store/U4etka/Main/add_products.dart';
import 'package:store/U4etka/Main/edit_product.dart';
import 'package:store/U4etka/Main/group.dart';

class Products extends StatefulWidget {
  final bool selectMode;

  Products({super.key, this.selectMode = false});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  List<DocumentSnapshot> group = [];
  List<DocumentSnapshot> products = [];
  List<DocumentSnapshot> filteredProducts = [];
  List<DocumentSnapshot> filteredGroup = [];
  bool isSearching = false;
  String searchQuery = '';

  Future getGroup() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('group').get();

      setState(() {
        group = collection.docs;
        filteredGroup = group;
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
        filteredProducts = products;
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

  Future<void> _refreshProducts() async {
    await getGroup();
    await getProducts();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      filteredGroup = group
          .where((grp) =>
              grp['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    clearSearchQuery();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearchQuery() {
    setState(() {
      searchQuery = '';
      filteredProducts = products;
      filteredGroup = group;
    });
  }

  void sortByName() {
    setState(() {
      filteredProducts.sort((a, b) => a['name'].compareTo(b['name']));
      filteredGroup.sort((a, b) => a['name'].compareTo(b['name']));
    });
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Поиск...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white,fontSize: 18),
      ),
      style: TextStyle(color: Colors.white, fontSize: 18),
      onChanged: updateSearchQuery,
    );
  }

  List<Widget> buildActions() {
    if (isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear,color: Colors.white,),
          onPressed: () {
            if (searchQuery.isEmpty) {
              Navigator.pop(context);
              return;
            }
            clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search,size: 25,color: Colors.white,),
        onPressed: startSearch,
      ),
      IconButton(
        icon: Icon(Icons.sort_by_alpha,color: Colors.white,),
        onPressed: sortByName,
      ),
    ];
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      'Товары',
      style: TextStyle(fontSize: 30, color: Colors.white),
    );
  }

  Widget buildLeading() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios_new,
        size: 25,
        color: Colors.white,
      ),
    );
  }

  Widget displayImage(String? imageUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            )
          : Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ),
            ),
    );
  }

  void selectProduct(DocumentSnapshot product) {
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildLeading(),
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        centerTitle: true,
        title: isSearching ? buildSearchField() : buildTitle(context),
        actions: buildActions(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredGroup.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Group(groupId: filteredGroup[index].id)),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                displayImage(filteredGroup[index]['photo']),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredGroup[index]['name'],
                                        style: TextStyle(fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.barcode_reader),
                                          Expanded(
                                            child: Text(
                                              filteredGroup[index]['scanner']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: filteredProducts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (widget.selectMode) {
                          selectProduct(filteredProducts[index]);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProduct(product: filteredProducts[index])),
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                displayImage(filteredProducts[index]['photo']),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredProducts[index]['name'],
                                        style: TextStyle(fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.barcode_reader),
                                          Expanded(
                                            child: Text(
                                              filteredProducts[index]['scanner']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        filteredProducts[index]['description'],
                                        style: TextStyle(fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  filteredProducts[index]['count'].toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Добавить товар",
              iconColor: Colors.white,
              bubbleColor: Color.fromARGB(210, 15, 145, 185),
              icon: Icons.add_circle_outline,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProducts()),
                );
              },
            ),
            Bubble(
              title: "Добавить группу",
              iconColor: Colors.white,
              bubbleColor: Color.fromARGB(210, 15, 145, 185),
              icon: Icons.add_circle_outline,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGroup()),
                );
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          iconData: Icons.add,
          backGroundColor: Color.fromARGB(210, 15, 145, 185),
        ),
      ),
    );
  }
}
