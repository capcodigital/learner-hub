import 'package:flutter/material.dart';
import 'package:flutter_confluence/toggle-switch.dart';
import '../../domain/entities/certification.dart';
import '../widgets/list_row.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ToggleButton(),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: certifications.length,
                itemBuilder: (BuildContext context, int position) {
                  return ListRow(item: certifications[position]);
                }),
          )
        ]));
  }
}
