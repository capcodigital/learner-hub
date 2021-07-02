import 'package:flutter/material.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'list_row.dart';

class CertificationsView extends StatelessWidget {
  final List<CloudCertification> items;
  CertificationsView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int position) {
          return ListRow(item: items[position]);
        });
  }
}
