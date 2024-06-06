import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseReport extends StatelessWidget {
  const ExpenseReport({Key? key}) : super(key: key);

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
        title: Text('Затраты',
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
          stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Нет данных'));
            }

            var expenseDocs = snapshot.data!.docs;

            return DataTable(
              columns: [
                DataColumn(label: Text('Дата')),
                DataColumn(label: Text('Сумма')),
                DataColumn(label: Text('Наименование')),
                
              ],
              
              rows: expenseDocs.map((expense) {
                return DataRow(cells: [
                  DataCell(Text(expense['date'])),
                  DataCell(Text(expense['sum'].toString())),
                  DataCell(Text(expense['title'])),
                
                ]);
                
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
