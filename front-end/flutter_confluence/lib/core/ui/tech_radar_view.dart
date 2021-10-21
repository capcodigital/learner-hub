import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);
  static const route = 'TechRadarPage';
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
