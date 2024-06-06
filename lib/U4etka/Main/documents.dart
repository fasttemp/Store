import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store/U4etka/Main/cost_docs.dart';
import 'package:store/U4etka/Main/income_docs.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new, size: 25, color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(210, 15, 145, 185),
          centerTitle: true,
          title: Text(
            'Документы',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 18),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Все'),
              Tab(text: 'Приходные'),
              Tab(text: 'Расходные'),
            ],
          ),
        ),
        body: TabBarView(
          children: [AllDocuments(), IncomeDocs(), CostDocs()],
        ),
      ),
    );
  }
}

class AllDocuments extends StatefulWidget {
  const AllDocuments({super.key});

  @override
  State<AllDocuments> createState() => _AllDocumentsState();
}

class _AllDocumentsState extends State<AllDocuments> {
  List<DocumentSnapshot> income = [];
  List<DocumentSnapshot> costs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getIncome();
    await getCosts();
  }

  Future<void> getIncome() async {
    try {
      QuerySnapshot collection = await FirebaseFirestore.instance.collection('income').get();
      setState(() {
        income = collection.docs;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getCosts() async {
    try {
      QuerySnapshot collection = await FirebaseFirestore.instance.collection('costs').get();
      setState(() {
        costs = collection.docs;
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

  int getTotalCostsCount(List<dynamic> products) {
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

  Future<void> refreshDocs() async {
    await getIncome();
    await getCosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshDocs,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDocumentsList(income, 'Приход'),
              buildDocumentsList(costs, 'Расход'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDocumentsList(List<DocumentSnapshot> documents, String docType) {
    Map<String, List<DocumentSnapshot>> groupedDocs = {};
    for (var doc in documents) {
      String date = (doc.data() as Map<String, dynamic>)['data'];
      if (!groupedDocs.containsKey(date)) {
        groupedDocs[date] = [];
      }
      groupedDocs[date]!.add(doc);
    }

    List<Widget> docWidgets = [];
    groupedDocs.forEach((date, docs) {
      docWidgets.add(Container(
        color: Color.fromARGB(210, 15, 145, 185),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
      docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> products = data.containsKey('products') ? data['products'] : [];
        int totalCount = getTotalProductCount(products);

        docWidgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                docType,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: docType == 'Приход' ? Colors.green : Colors.red,
                ),
              ),
              Row(
                children: [
                  Text('Док №', style: TextStyle(fontSize: 17)),
                  Text(data.containsKey('id') ? data['id'].toString() : 'error', style: TextStyle(fontSize: 15)),
                ],
              ),
              Row(
                children: [
                  Text(data.containsKey('data') ? data['data'] : 'error', style: TextStyle(fontSize: 15)),
                  Spacer(),
                  Text(totalCount.toString(), style: TextStyle(fontSize: 17)),
                ],
              ),
              Text(data.containsKey('title') ? data['title'] : 'error', style: TextStyle(fontSize: 17)),
              Text(data.containsKey('description') ? data['description'] : 'error', style: TextStyle(fontSize: 17)),
              Divider(),
            ],
          ),
        ));
      });
    });

    return Column(children: docWidgets);
  }
}