import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/U4etka/Persons/add_provider.dart';
import 'package:store/U4etka/Persons/persons.dart';
import 'package:store/U4etka/Persons/provider.dart';
import 'package:store/U4etka/bottom_menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'U4etka/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyASl_lsMj4XlUkOd478gxfXrZqT3QQ8Uqw',
          appId: '1:495928311341:android:ef3abb3b92873051a702a4',
          messagingSenderId: '495928311341',
          projectId: 'store-a3d9b',
          storageBucket: 'store-a3d9b.appspot.com'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          locale: Locale('ru', 'RU'),
          home: BottomMenu(),
          theme: ThemeData(
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            fontFamily: themeProvider.fontFamily,
          ),
        );
      },
    );
  }
}
