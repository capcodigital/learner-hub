import 'package:flutter/material.dart';
import '../../domain/entities/certification.dart';

final double listRowIconSize = 50.0;
final double listRowIconRightMargin = 22.0;
final double listRowUserTextSize = 18.0;
final double listRowInfoMarginTop = 10.0;
final double listRowInfoTextSize = 12.0;
final double listRowDateTextSize = 14.0;

class ListRow extends StatelessWidget {
  final Certification item;
  ListRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return getRow(item);
  }

  Widget getRow(Certification item) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Container(
                width: listRowIconSize,
                height: listRowIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/${item.certificationIconName}')))),
            Padding(
              padding: EdgeInsets.only(left: listRowIconRightMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.userName,
                    style: TextStyle(
                        color: Colors.black, fontSize: listRowUserTextSize),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: listRowInfoMarginTop),
                    child: Text(
                      item.certificationTitle,
                      style: TextStyle(
                          color: Colors.grey, fontSize: listRowInfoTextSize),
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
                  style: TextStyle(
                      color: Colors.grey, fontSize: listRowDateTextSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
