import 'package:flutter/material.dart';
import 'package:litt/locator.dart';
import 'package:litt/scratch_view.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Litt',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.0,
            ),
      ),
      home: ScratchView(),
    );
  }
}
