import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:migong/screen/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp() 호출 전 Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '${dotenv.env['NATIVE_APP_KEY']}',
    javaScriptAppKey: '${dotenv.env['JAVASCRIPT_APP_KEY']}',
  );
  // await Future.delayed(Duration(seconds: 2));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
    initialRoute: '/',
    routes: {},
  ));
}
