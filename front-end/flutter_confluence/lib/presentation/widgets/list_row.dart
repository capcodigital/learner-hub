import 'package:flutter/material.dart';
import '../../domain/entities/certification.dart';

class ListRow extends StatelessWidget {
  static const listRowIconSize = 50.0;
  static const listRowIconPadding = 16.0;
  static const listRowIconRightMargin = 23.0;
  static const listRowUserTextSize = 16.0;
  static const listRowInfoMarginTop = 10.0;
  static const listRowInfoTextSize = 12.0;
  static const listRowInfoTextColor = Color(0xBF000000);
  static const listRowDateTextSize = 14.0;

  final Certification item;
  ListRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return getRow(item, context);
  }

  Widget getRow(Certification item, BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(listRowIconPadding),
        child: Row(
          children: <Widget>[
            Container(
                width: listRowIconSize,
                height: listRowIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/${item.icon}')))),
            Padding(
              padding: EdgeInsets.only(left: listRowIconRightMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: TextStyle(
                        color: Colors.black, fontSize: listRowUserTextSize),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: listRowInfoMarginTop),
                    child: Text(
                      item.certification,
                      style: TextStyle(
                          color: listRowInfoTextColor,
                          fontSize: listRowInfoTextSize),
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
                  item.date,
                  style: TextStyle(
                      color: listRowInfoTextColor,
                      fontSize: listRowDateTextSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
