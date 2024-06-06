import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/U4etka/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = Color.fromARGB(210, 15, 145, 185);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: Text(
          'Настройки',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Внешний вид',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(themeProvider.isDarkMode ? 'Темная тема' : 'Светлая тема'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.setTheme(value);
              },
              activeColor: appBarColor,
            ),
            SizedBox(height: 20),
            Text(
              'Шрифты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: themeProvider.fontFamily,
              items: ['Roboto', 'Arial', 'Georgia',].map((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setFontFamily(newValue);
                }
              },
              style: TextStyle(color: appBarColor),
              dropdownColor: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
