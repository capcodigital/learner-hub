import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class ListRow extends StatelessWidget {
  static const listRowIconSize = 60.0;
  static const listRowIconBorderWidth = 1.0;
  static const listRowIconBorderColor = Constants.JIRA_COLOR;
  static const listRowIconPadding = 16.0;
  static const listRowIconRightMargin = 23.0;
  static const listRowUserTextColor = Colors.black;
  static const listRowUserTextSize = 16.0;
  static const listRowInfoMarginTop = 10.0;
  static const listRowInfoTextSize = 12.0;
  static const listListRowInfoTextColor = Constants.BLACK_75;
  static const listListRowDateTextSize = 14.0;

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
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/${item.certificationIconName}'),
                  ),
                  width: listRowIconSize,
                  height: listRowIconSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: listRowIconBorderColor,
                      width: listRowIconBorderWidth,
                    ),
                  )),
              title: Text(
                  item.name,
                  style: TextStyle(color: listRowUserTextColor)
              ),
              subtitle: Row(
                children: [
                  Expanded(
                      child:
                      Text(
                          item.certificationType,
                      style: TextStyle(color: listListRowInfoTextColor),)),
                  Text(
                    item.certificationDate,
                    style: TextStyle(color: listListRowInfoTextColor),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
