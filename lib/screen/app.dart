import 'package:flutter/material.dart';
import 'package:migong/screen/custom_splash.dart';
import 'package:migong/screen/custom_webview.dart';
import 'package:migong/screen/my_page.dart';
import 'package:migong/widget/bottom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class App extends StatefulWidget {
  bool firstSplash = false;
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  WebViewController? controller;

  int _selectedIndex = 0;
  int process = 0;
  bool secondSplash = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              CustomSplash(showState: widget.firstSplash),
              CustomWebView(
                onWebViewCreated: _webViewControllerManage,
                setProcess: _setProcess,
              ),
              MyPage(showState: (_selectedIndex != 2)),
              CustomSplash(showState: secondSplash),
            ],
          ),
        ),
      ),
    );
  }

  void _setProcess(int process) {
    setState(() {
      process = process;
    });
    if (process == 100) {
      Future.delayed(
          Duration(seconds: 1),
          () => {
                setState(() {
                  secondSplash = true;
                })
              });
    }
  }

  void _webViewControllerManage(WebViewController controller) {
    this.controller = controller;
  }
}
