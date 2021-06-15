import 'package:flutter/material.dart';
import 'package:flutter_confluence/certification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<HomeScreen> {
  Widget getRow(Certification item) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/${item.certificationIconName}')))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.userName,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        item.certificationTitle,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.certificationDate,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: ListView.builder(
            itemCount: dummyItems.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(dummyItems[position]);
            }));
  }
}
