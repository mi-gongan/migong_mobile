import 'package:flutter/material.dart';
import 'package:migong/screen/custom_webview.dart';
import 'package:migong/screen/my_page.dart';
import 'package:migong/widget/bottom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  WebViewController? controller;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('migong'),
            backgroundColor: Colors.black,
            toolbarHeight: 80.0,
          ),
          body: Stack(
            children: <Widget>[
              CustomWebView(onWebViewCreated: _webViewControllerManage),
              MyPage(showState: (_selectedIndex != 2))
            ],
          ),
          bottomNavigationBar: BottomBar(
            onTap: _onItemTapped,
            selectedIndex: _selectedIndex,
          )),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _webViewControllerManage(WebViewController controller) {
    this.controller = controller;
  }
}
