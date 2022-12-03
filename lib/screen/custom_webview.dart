import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final baseUrl;
  WebViewCreatedCallback? onWebViewCreated;
  Function(bool) handleLoginOff;

  CustomWebView(
      {required this.onWebViewCreated,
      required this.baseUrl,
      required this.handleLoginOff,
      super.key});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: widget.onWebViewCreated,
      initialUrl: widget.baseUrl,
      javascriptMode: JavascriptMode.unrestricted,
      //swipe 가능
      gestureNavigationEnabled: true,
      //구글 로그인 가능
      userAgent: "random",
      javascriptChannels: <JavascriptChannel>{
        _webToAppChange(context),
      },
    );
  }

  JavascriptChannel _webToAppChange(BuildContext context) {
    return JavascriptChannel(
        name: 'webviewChannel',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          if (message.message == "logout") {
            widget.handleLoginOff(false);
          }
        });
  }
}
