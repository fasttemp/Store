import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomeReport extends StatelessWidget {
  const IncomeReport({Key? key}) : super(key: key);

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
        )),
        title: Text('Приход',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('income').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Нет данных'));
            }

            var incomeDocs = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Дата')),
                  DataColumn(label: Text('Номер')),
                  DataColumn(label: Text('Описание')),
                  DataColumn(label: Text('Продукты')),
                ],
                rows: incomeDocs.map((income) {
                  return DataRow(cells: [
                    DataCell(Text(income['data'])),
                    DataCell(Text(income['id'].toString())),
                    DataCell(Text(income['description'])),
                    DataCell(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: income['products'].map<Widget>((product) {
                        return Text(
                            '${product['name']} (Кол-во: ${product['count']})');
                      }).toList(),
                    )),
                  ]);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
