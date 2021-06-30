import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class ListRow extends StatelessWidget {
  static const listRowIconSize = 60.0;
  static const listRowIconBorderWidth = 1.0;
  static const listRowIconBorderColor = Constants.JIRA_COLOR;
  static const listRowIconPadding = 16.0;
  static const listRowIconRightMargin = 23.0;

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
                    backgroundImage:
                        AssetImage('assets/${item.certificationIconName}'),
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
              title:
                  Text(item.name, style: Theme.of(context).textTheme.headline2),
              subtitle: Row(
                children: [
                  Expanded(
                      child: Text(item.certificationType,
                          style: Theme.of(context).textTheme.headline3)),
                  Text(
                    item.certificationDate,
                    style: Theme.of(context).textTheme.headline3,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
