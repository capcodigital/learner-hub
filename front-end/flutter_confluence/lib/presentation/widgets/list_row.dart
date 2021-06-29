import 'package:flutter/material.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class ListRow extends StatelessWidget {
  static const LIST_ROW_ICON_SIZE = 60.0;
  static const LIST_ROW_ICON_BORDER_WIDTH = 1.0;
  static const LIST_ROW_ICON_BORDER_COLOR = Color(0xFF0052CC);
  static const LIST_ROW_ICON_PADDING = 16.0;
  static const LIST_ROW_ICON_RIGHT_MARGIN = 23.0;
  static const LIST_ROW_USER_TEXT_SIZE = 16.0;
  static const LIST_ROW_INFO_MARGIN_TOP = 10.0;
  static const LIST_ROW_INFO_TEXT_SIZE = 12.0;
  static const LIST_ROW_INFO_TEXT_COLOR = Color(0xBF000000);
  static const LIST_ROW_DATE_TEXT_SIZE = 14.0;

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
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/${item.certificationIconName}'),
                  ),
                  width: LIST_ROW_ICON_SIZE,
                  height: LIST_ROW_ICON_SIZE,
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: LIST_ROW_ICON_BORDER_COLOR,
                      width: LIST_ROW_ICON_BORDER_WIDTH,
                    ),
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
