import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/bottom_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyASl_lsMj4XlUkOd478gxfXrZqT3QQ8Uqw',
     appId: '1:495928311341:android:ef3abb3b92873051a702a4',
      messagingSenderId: '495928311341',
       projectId: 'store-a3d9b',
       storageBucket: 'store-a3d9b.appspot.com'
       ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomMenu());
  }
}
