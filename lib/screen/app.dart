import 'package:flutter/material.dart';
import 'package:migong/screen/custom_splash.dart';
import 'package:migong/screen/custom_webview.dart';
import 'package:migong/screen/login_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class App extends StatefulWidget {
  bool splashOff = false;
  final baseUrl = "http://localhost:3000";
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  WebViewController? webViewController;
  bool loginScreenOff = false;
  final cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              CustomSplash(offstage: widget.splashOff),
              CustomWebView(
                  onWebViewCreated: _webViewControllerManage,
                  baseUrl: widget.baseUrl),
              LoginScreen(
                  webViewController: webViewController,
                  cookieManager: cookieManager,
                  offstage: loginScreenOff,
                  baseUrl: widget.baseUrl),
            ],
          ),
        ),
      ),
    );
  }

  void _webViewControllerManage(WebViewController controller) {
    this.webViewController = controller;
  }
}
