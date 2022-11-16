import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  WebViewController? webViewController;
  CookieManager? cookieManager;
  bool offstage;
  final baseUrl;

  LoginScreen(
      {required this.webViewController,
      required this.cookieManager,
      required this.offstage,
      required this.baseUrl,
      super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = new FlutterSecureStorage();
  final db = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.offstage,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(onPressed: kakaoLogin, child: Text('userinfo')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getToken() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken? token = await UserApi.instance.loginWithKakaoTalk();
        await TokenManagerProvider.instance.manager.setToken(token);
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          OAuthToken? token = await UserApi.instance.loginWithKakaoAccount();
          await TokenManagerProvider.instance.manager.setToken(token);
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken? token = await UserApi.instance.loginWithKakaoAccount();
        await TokenManagerProvider.instance.manager.setToken(token);
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future kakaoLogin() async {
    //token
    if (!await AuthApi.instance.hasToken()) {
      try {
        await getToken();
      } catch (error) {
        print('token setting 실패 $error');
      }
    }
    try {
      User user = await UserApi.instance.me();

      //firebase
      var rnd = Random().nextInt(10000).toString();
      final data = {
        "email": user.kakaoAccount?.email,
        'image': user.kakaoAccount?.profile?.profileImageUrl,
        'nickname': user.kakaoAccount?.profile?.nickname,
        'state': 'login',
        'nonce': rnd,
      };
      db
          .collection("users")
          .doc(user.kakaoAccount?.email)
          .set(data, SetOptions(merge: true));

      await widget.webViewController?.loadUrl(
          widget.baseUrl + "/login/${user.kakaoAccount?.email}/${rnd}");
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  void init() async {
    // final docRef = db.collection("users").doc(email);
    // docRef.get().then(
    //   (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     print(data);
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
  }
}
