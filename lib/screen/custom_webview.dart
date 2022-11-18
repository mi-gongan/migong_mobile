import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  final baseUrl;
  WebViewCreatedCallback? onWebViewCreated;

  CustomWebView(
      {required this.onWebViewCreated, required this.baseUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: onWebViewCreated,
      initialUrl: baseUrl,
      javascriptMode: JavascriptMode.unrestricted,
      //swipe 가능
      gestureNavigationEnabled: true,
      //구글 로그인 가능
      userAgent: "random",
    );
  }
}
