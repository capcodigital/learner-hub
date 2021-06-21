import 'package:flutter/material.dart';
import '../../domain/entities/certification.dart';
import 'list_row.dart';

class CartificationsView extends StatelessWidget {
  final List<Certification> items;
  CartificationsView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int position) {
          return ListRow(item: items[position]);
        });
  }
}
