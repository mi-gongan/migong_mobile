import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  final homeUrl = "http://localhost:3000";
  final WebViewCreatedCallback? onWebViewCreated;

  const CustomWebView({required this.onWebViewCreated, super.key});

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: onWebViewCreated,
      initialUrl: homeUrl,
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: true,
    );
  }
}
