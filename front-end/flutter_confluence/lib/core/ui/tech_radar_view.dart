import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TechRadarView extends StatefulWidget {
  const TechRadarView({Key? key}) : super(key: key);
  static const route = 'TechRadarPage';
  @override
  TechRadarViewState createState() => TechRadarViewState();
}

class TechRadarViewState extends State<TechRadarView> {
  TextStyle optionStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title:
              Text('Tech Radar', style: Theme.of(context).textTheme.headline1),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Center(
            child: WebView(
          initialUrl: 'https://master.d3qm5n59wrk3b.amplifyapp.com/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('https://master.d3qm5n59wrk3b.amplifyapp.com/')) {
              print('allowing navigation to $request}');
              return NavigationDecision.navigate;
            }
            print('blocking navigation to $request');
            return NavigationDecision.prevent;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: false,
        )));
  }
}
