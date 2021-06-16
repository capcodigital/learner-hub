import 'package:flutter/material.dart';
import '../../domain/entities/certification.dart';
import '../widgets/list_row.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: ListView.builder(
            itemCount: certifications.length,
            itemBuilder: (BuildContext context, int position) {
              return ListRow(item: certifications[position]);
            }));
  }
}
