import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.appBar}) : super(key: key);
  static const route = 'HomePage';
  final PreferredSizeWidget appBar;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static const double frontLayerInitialTop = 130;
  static const double parallaxSmoothFactor = 0.1;
  var frontLayerTop = frontLayerInitialTop;
  var disableSearchAndToggle = false;
  final TextEditingController searchController = TextEditingController();
  late MediaQueriesImpl mediaQueries;

  @override
  Widget build(BuildContext context) {
    mediaQueries = MediaQueriesImpl(buildContext: context);
    return Scaffold(
      // Fixes bottom overflow error when show keyboard in landscape
      resizeToAvoidBottomInset: false,
      appBar: widget.appBar,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.scrollDelta != null) {
              final delta = notification.scrollDelta!;
              setState(() {
                frontLayerTop += delta * parallaxSmoothFactor;
              });
            }
          }
          return true;
        },
        child: Container(
            width: mediaQueries.applyWidth(context, 1),
            height: mediaQueries.applyHeight(context, 1),
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/back-layer.png'), fit: BoxFit.cover)),
            child: LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
              final parallaxLayerLeft = mediaQueries.isPortrait(ctx)
                  ? constraints.maxWidth * LayoutConstants.SMALL_SCALE
                  : constraints.maxWidth * LayoutConstants.LARGE_SCALE;
              return Stack(
                children: <Widget>[
                  Positioned(
                    left: parallaxLayerLeft,
                    top: frontLayerTop,
                    child: Image.asset('assets/front-layer.png'),
                  ),
                  const Text('Add here your new UI', key: Key('sampleText'))
                ],
              );
            })));
  }
}
