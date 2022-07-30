import 'package:flutter/material.dart';

// main関数
void main() {
  runApp(myMap());
}

// Stateless Widgetを継承したmyMppクラス
class myMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Map'),
        ),
        body: const Center(
          child: Text('Hello to Flutter World'),
        ),
      ),
    );
  }
}