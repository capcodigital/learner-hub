import 'package:flutter/material.dart';
import '../widgets/list_view_certif.dart';
import '../../domain/entities/certification.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: ListViewCertif(items: certifications));
  }
}
