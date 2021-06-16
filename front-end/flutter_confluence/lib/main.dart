import 'package:flutter/material.dart';
import 'package:flutter_confluence/toggle-switch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Confluence'),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ToggleButton()],
              ),
            ),
          ),
        ));
  }
}
