import 'package:flutter/material.dart';
import '../../domain/entities/certification.dart';
import 'list_row.dart';

class ListViewCertif extends StatelessWidget {
  final List<Certification> items;
  ListViewCertif({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: certifications.length,
        itemBuilder: (BuildContext context, int position) {
          return ListRow(item: items[position]);
        });
  }
}
