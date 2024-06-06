import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:store/U4etka/Persons/add_buyers.dart';
import 'package:store/U4etka/Persons/edit_buyer.dart';

class Buyers extends StatefulWidget {
  const Buyers({
    Key? key,
  }) : super(key: key);

  @override
  State<Buyers> createState() => _BuyersState();
}

class _BuyersState extends State<Buyers> {
  List<DocumentSnapshot> buyers = [];
  List<DocumentSnapshot> filteredBuyers = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isSorted = true;

  @override
  void initState() {
    super.initState();
    getBuyers();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Future getBuyers() async {
    try {
      QuerySnapshot collection = await FirebaseFirestore.instance
          .collection('buyers')
          .orderBy('name')
          .get();
      setState(() {
        buyers = collection.docs;
        filteredBuyers = buyers;
      });
    } catch (e) {
      print(e);
    }
  }

  Future filterBuyers(String query) async {
    List<DocumentSnapshot> tempSearchList = [];
    tempSearchList.addAll(buyers);

    if (query.isNotEmpty) {
      List<DocumentSnapshot> tempList = [];
      tempSearchList.forEach((element) {
        if (element['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          tempList.add(element);
        }
        setState(() {
          filteredBuyers = tempList;
          sortBuyers();
        });
      });
      return;
    } else {
      setState(() {
        filteredBuyers = buyers;
        sortBuyers();
      });
    }
  }

  void sortBuyers() {
    setState(() {
      if (isSorted) {
        filteredBuyers.sort((a, b) => a['name'].compareTo(b['name']));
      } else {
        filteredBuyers.sort((a, b) => b['name'].compareTo(a['name']));
      }
    });
  }

  Future deleteBuyer(String buyerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(buyerId)
          .delete();
      setState(() {
        buyers.removeWhere((buyer) => buyer.id == buyerId);
        filterBuyers(searchController.text);
      });
      print('Документ успешно удален !');
    } catch (e) {
      print('Не удалось удалить документ : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03dac6),
        title: isSearching
            ? null
            : Row(
          children: [
            Text('Покупатели',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ],
              ),
        actions: [
          isSearching
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        filterBuyers(value);
                      },
                    ),
                  ),
                )
              : Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 35,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isSorted = !isSorted;
                            sortBuyers();
                          });
                        },
                        icon: Icon(
                          isSorted ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 35,
                        ))
                  ],
                )
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(indent: 500, height: 1),
        itemCount: filteredBuyers.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditBuyer(buyer: filteredBuyers[index])));

              if (result == true) {
                getBuyers();
              }
            },
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      buyers[index]['name'],
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    InkWell(
                      child: Icon(Icons.delete, size: 30),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              content: Text(
                                'Вы точно хотите удалить данную запись?',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Нет'),
                              ),
                              TextButton(
                                onPressed: () {
                                    deleteBuyer(filteredBuyers[index].id);
                                  Navigator.pop(context);
                                },
                                child: Text('Да'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Divider(),
            ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBuyers()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
