import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  final Completer<WebViewController>? webViewController;
  final String baseUrl;

  LoginScreen(
      {required this.webViewController, required this.baseUrl, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final db = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();
  bool logined = false;

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: logined,
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
      var userAccount = user.kakaoAccount;
      print('login!');

      //firebase
      var nonce = getRandomString(33);
      final data = {
        "email": userAccount?.email,
        'image': userAccount?.profile?.profileImageUrl,
        'nickname': userAccount?.profile?.nickname,
        'state': 'request',
        'nonce': nonce,
      };
      db
          .collection("users")
          .doc(userAccount?.email)
          .set(data, SetOptions(merge: true));
      print('set db!');

      // web validate
      widget.webViewController!.future.then((value) {
        value.loadUrl(widget.baseUrl + "/login/${userAccount?.email}/${nonce}");
      });
      print("load url");

      // wait
      Future.delayed(Duration(milliseconds: 1000), () async {
        await storage.write(key: 'email', value: userAccount?.email);
        setState(() {
          logined = true;
        });
      });
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

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
