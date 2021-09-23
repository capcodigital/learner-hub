import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';

class ListRow extends StatelessWidget {
  const ListRow({required this.item});
  static const listRowIconBorderWidth = 1.0;
  static const listRowIconBorderColor = Constants.JIRA_COLOR;

  final CloudCertification item;

  @override
  Widget build(BuildContext context) {
    return getRow(item, context);
  }

  Widget getRow(CloudCertification item, BuildContext context) {
    final iconSize = kIsWeb
        ? getWidth(context, Dimen.scale_3_100)
        : isPortrait(context)
            ? getWidth(context, Dimen.scale_12_100)
            : getWidth(context, Dimen.scale_6_100);
    final iconBorder = isPortrait(context)
        ? iconSize * Dimen.scale_25_1000
        : iconSize * Dimen.scale_2_100;
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
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: listRowIconBorderColor,
                      width: iconBorder,
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
