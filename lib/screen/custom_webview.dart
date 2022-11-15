import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  final homeUrl = "http://localhost:3000";
  void Function(int) setProcess;
  final WebViewCreatedCallback? onWebViewCreated;

  CustomWebView(
      {required this.onWebViewCreated, required this.setProcess, super.key});

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: onWebViewCreated,
      initialUrl: homeUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onProgress: setProcess,
      javascriptChannels: <JavascriptChannel>{
        _webToAppChange(context),
      },
      //swipe 가능
      gestureNavigationEnabled: true,
      //구글 로그인 가능
      userAgent: "random",
    );
  }

  JavascriptChannel _webToAppChange(BuildContext context) {
    return JavascriptChannel(
        name: 'port1',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print("webToAppChange 메시지 : ${message.message}");
        });
  }
}
