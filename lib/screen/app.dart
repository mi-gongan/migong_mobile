import 'dart:async';

import 'package:flutter/material.dart';
import 'package:migong/components/app/custom_splash.dart';
import 'package:migong/components/app/custom_webview.dart';
import 'package:migong/components/app/login_screen.dart';
import 'package:migong/components/common/go_to_route_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class App extends StatefulWidget {
  bool splashOff = false;
  // final baseUrl = "http://localhost:3000";
  // final baseUrl = "https://migong.vercel.app";
  final baseUrl = "https://migong-webview.vercel.app/";
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Completer<WebViewController> webViewController =
      Completer<WebViewController>();
  bool loginOff = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              // CustomSplash(offstage: widget.splashOff),
              Text("Sdfsdf"),
              CustomWebView(
                  onWebViewCreated: onWebViewCreated,
                  baseUrl: widget.baseUrl,
                  handleLoginOff: handleLoginOff),
              // LoginScreen(
              //     webViewController: webViewController,
              //     baseUrl: widget.baseUrl,
              //     loginOff: loginOff,
              //     handleLoginOff: handleLoginOff),
              // const GoToRouteButton(
              //   routeName: "/camera",
              //   text: "router",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void onWebViewCreated(WebViewController controller) {
    webViewController.complete(controller);
  }

  void handleLoginOff(bool state) {
    print(loginOff);
    print(state);
    setState(() {
      loginOff = state;
    });
  }
}
