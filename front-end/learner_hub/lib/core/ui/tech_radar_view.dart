import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);
  static const route = 'TechRadarPage';

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  TextStyle optionStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const String _TECH_RADAR_HOME_PAGE = 'https://master.d3qm5n59wrk3b.amplifyapp.com/';
  final whitelistedURLs = [_TECH_RADAR_HOME_PAGE];

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
          title: Text('Tech Radar', style: Theme.of(context).textTheme.headline1),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Center(
            child: WebView(
          initialUrl: _TECH_RADAR_HOME_PAGE,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          navigationDelegate: _handleNavigation,
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: false,
        )));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    if (whitelistedURLs.any((url) => request.url.startsWith(url))) {
      print('Allowing navigation to ${request.url}');
      return NavigationDecision.navigate;
    } else {
      print('URL ${request.url} not in whitelist - Opening in external browser');
      launch(request.url);
      return NavigationDecision.prevent;
    }
  }
}
