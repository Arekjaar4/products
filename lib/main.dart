import 'package:flutter/material.dart';
import 'package:myapp/ui/admin_ui.dart';

import 'database/database/web.dart';
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final db = constructDb();
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Productos', db: db),
    );
  }
}
