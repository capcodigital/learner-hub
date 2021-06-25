import 'package:flutter/material.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class ListRow extends StatelessWidget {
  static const listRowIconSize = 60.0;
  static const listRowIconBorderWidth = 3.0;
  static const listRowIconPadding = 16.0;
  static const listRowIconRightMargin = 23.0;
  static const listRowUserTextSize = 16.0;
  static const listRowInfoMarginTop = 10.0;
  static const listRowInfoTextSize = 12.0;
  static const listRowInfoTextColor = Color(0xBF000000);
  static const listRowDateTextSize = 14.0;

  final CloudCertification item;
  ListRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return getRow(item, context);
  }

  Widget getRow(CloudCertification item, BuildContext context) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Container(
                  child: new CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/${item.certificationIconName}'),
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent),
                  width: listRowIconSize,
                  height: listRowIconSize,
                  padding: EdgeInsets.all(listRowIconBorderWidth),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                  )),
              title: Text(item.name),
              subtitle: Row(
                children: [
                  Expanded(child: Text(item.certificationType)),
                  Text(
                    item.certificationDate,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
