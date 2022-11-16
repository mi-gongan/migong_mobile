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
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
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
