import 'package:flutter/material.dart';
import 'package:migong/screen/app.dart';

void main() async {
  await Future.delayed(Duration(seconds: 2));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
    initialRoute: '/',
    routes: {},
  ));
}
