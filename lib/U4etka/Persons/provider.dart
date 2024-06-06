import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Persons/add_provider.dart';
import 'package:store/U4etka/Persons/edit_provider.dart';

class Provider extends StatefulWidget {
  final bool selectMode;

  const Provider({super.key, this.selectMode = false});

  @override
  State<Provider> createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  List<DocumentSnapshot> providers = [];
  List<DocumentSnapshot> filteredProviders = [];
  bool showSearchBar = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProviders();
  }

  Future<void> getProviders() async {
    try {
      QuerySnapshot collection =
          await FirebaseFirestore.instance.collection('provider').get();
      setState(() {
        providers = collection.docs;
        sortedProviders();
      });
    } catch (e) {
      print(e);
    }
  }

  void sortedProviders() {
    providers.sort((a, b) {
      String nameA = a['name'] ?? '';
      String nameB = b['name'] ?? '';
      return nameA.compareTo(nameB);
    });
    filteredProviders = List.from(providers);
  }

  Future<void> deleteProvider(String providerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('provider')
          .doc(providerId)
          .delete();
      setState(() {
        providers.removeWhere((provider) => provider.id == providerId);
        filteredProviders.removeWhere((provider) => provider.id == providerId);
      });
      print('Документ успешно удален!');
    } catch (e) {
      print('Не удалось удалить документ: $e');
    }
  }

  void searchProvider(String query) {
    setState(() {
      filteredProviders = providers
          .where((provider) => provider['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void showOptionsMenu(
      BuildContext context, Offset offset, DocumentSnapshot provider) {
        
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 20,
        offset.dy + 20,
        offset.dx - 20,
        offset.dy + 1,
      ),
      color: Color.fromARGB(210, 15, 145, 185),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit,color: Colors.white),
            title: Text('Редактировать',style: TextStyle(color: Colors.white),),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProvider(provider: provider),
                ),
              );

              if (result == true) {
                getProviders();
              }
            },
          ),
        ),
        PopupMenuItem(
          
          child: ListTile(
            leading: Icon(Icons.delete,color: Colors.white),
            title: Text('Удалить',style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Color.fromARGB(210, 15, 145, 185),
                  content: Text(
                    'Вы точно хотите удалить данную запись?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Нет',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteProvider(provider.id);
                        Navigator.pop(context);
                      },
                      child: Text('Да',style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
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
            )),
        centerTitle: true,
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        title: showSearchBar
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: ' Поиск ...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 20),
                ),
                style: TextStyle(color: Colors.white, fontSize: 20),
                enableSuggestions: false,
                cursorColor: Colors.white,
                onChanged: (value) {
                  searchProvider(value);
                },
              )
            : Text('Поставщики',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 17),
            icon: showSearchBar
                ? Icon(
                    Icons.cancel,
                    size: 35,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.search,
                    size: 35,
                    color: Colors.white,
                  ),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
                if (!showSearchBar) {
                  searchController.clear();
                  searchProvider('');
                }
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(indent: 500, height: 1),
        itemCount: filteredProviders.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (widget.selectMode) {
                Navigator.pop(context, filteredProviders[index]);
              }
            },
            onTapDown: (details) {
              if (!widget.selectMode) {
                showOptionsMenu(
                  
                    context, details.globalPosition, filteredProviders[index]);
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
                        filteredProviders[index]['name'],
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(Icons.more_vert),
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
        backgroundColor: Color.fromARGB(210, 15, 145, 185),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProvider()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
