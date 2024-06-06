import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IncomeDocs extends StatefulWidget {
  const IncomeDocs({super.key});

  @override
  State<IncomeDocs> createState() => _IncomeDocsState();
}

class _IncomeDocsState extends State<IncomeDocs> {
  List<DocumentSnapshot> income = [];

  @override
  void initState() {
    super.initState();
    getIncome();
  }

  Future getIncome() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('income').get();
      setState(() {
        income = collection.docs;
      });
    } catch (error) {
      print(error);
    }
  }

  int getTotalProductCount(List<dynamic> products) {
    int totalCount = 0;
    for (var product in products) {
      if (product is Map<String, dynamic> && product.containsKey('count')) {
        var count = product['count'];
        if (count is int) {
          totalCount += count;
        } else if (count is String) {
          totalCount += int.tryParse(count) ?? 0;
        }
      }
    }
    return totalCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: income.length,
        itemBuilder: (BuildContext context, int index) {
          // Получение данных из текущего документа
          Map<String, dynamic> data =
              income[index].data() as Map<String, dynamic>;

          // Получение списка продуктов из текущего документа
          List<dynamic> products =
              data.containsKey('products') ? data['products'] : [];
          int totalCount = getTotalProductCount(products);

          bool isNewDate = false;
          if (index == 0 ||
              (income[index - 1].data() as Map<String, dynamic>)['data'] !=
                  data['data']) {
            isNewDate = true;
          }

          return Column(
            children: [
              if (isNewDate)
                Container(
                  color: Color.fromARGB(210, 15, 145, 185),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      data['data'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 100,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Док №',
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                data.containsKey('id')
                                    ? data['id'].toString()
                                    : 'error',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                data.containsKey('data')
                                    ? data['data']
                                    : 'error',
                                style: TextStyle(fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                totalCount.toString(),
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                          Text(
                            data.containsKey('title') ? data['title'] : 'error',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            data.containsKey('description')
                                ? data['description']
                                : 'error',
                            style: TextStyle(fontSize: 17),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
