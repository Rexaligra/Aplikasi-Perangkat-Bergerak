import 'package:flutter/material.dart';
import 'package:profile_page/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Referensi : https://stackoverflow.com/questions/62108798/how-to-save-page-state-on-revisit-in-flutter
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}
