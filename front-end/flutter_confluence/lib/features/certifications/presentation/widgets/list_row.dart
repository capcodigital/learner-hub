import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/device.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
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

  double _applyIconSize(
      double cloudCertificationIconSize,
      BuildContext context) {
    final MediaQueriesImpl mediaQueries = MediaQueriesImpl(buildContext: context);
    final DeviceImpl device = DeviceImpl.getDefault();
    final iconSize = device.isWeb
        ? mediaQueries.applyWidgetSize(cloudCertificationIconSize,
        LayoutConstants.SMALL_SCALE)
        : mediaQueries.isPortrait(context)
            ? mediaQueries.applyWidgetSize(cloudCertificationIconSize,
        LayoutConstants.EXTRA_SMALL_SCALE)
            : mediaQueries.applyWidgetSize(cloudCertificationIconSize,
        LayoutConstants.SMALL_SCALE);
                return iconSize;
  }

  Widget getRow(CloudCertification item, BuildContext context) {
    final iconSize = _applyIconSize(60.0, context);
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
                      width: 2.0,
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
