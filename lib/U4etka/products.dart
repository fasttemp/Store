import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/add_group.dart';

class Products extends StatefulWidget {
 final String name;
 final String scanner;

  Products({super.key, required this.name, required this.scanner});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Товары', style: TextStyle(fontSize: 25)),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(''),

            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
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
              title: "Копировать",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.copy,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Добавить Товар",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.add_box,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
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
        ));
  }
}
