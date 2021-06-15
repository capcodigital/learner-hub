import 'package:flutter/material.dart';

import './item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: ListView.builder(
            itemCount: dummyItems.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  Widget getRow(int position) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage:
                AssetImage('assets/${dummyItems[position].iconName}'),
          ),
          title: Text(dummyItems[position].user),
          subtitle: Text(dummyItems[position].certificationTitle),
          trailing: Text(dummyItems[position].date),
        ),
      ),
    );
  }
}
