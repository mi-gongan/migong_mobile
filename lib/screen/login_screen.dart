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
  bool loginOff;
  Function(bool) handleLoginOff;

  LoginScreen(
      {required this.webViewController,
      required this.baseUrl,
      required this.loginOff,
      required this.handleLoginOff,
      super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final db = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.loginOff,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 560,
                ),
                InkWell(
                  onTap: kakaoLogin,
                  child: Image(
                    image: AssetImage("assets/img/kakao_login_large_wide.png"),
                    height: 55.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
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
      Future.delayed(Duration(seconds: 2), () async {
        widget.webViewController!.future.then((value) {
          value.loadUrl(
              widget.baseUrl + "/login/${userAccount!.email}/${nonce}");
        });
        print("load url");
        // wait
        Future.delayed(Duration(seconds: 1), () async {
          await storage.write(key: 'email', value: userAccount?.email);
          print("storage keep");
          widget.handleLoginOff(true);
        });
      });
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  void init() async {
    var email = await storage.read(key: "email");
    print(email);
    if (email != null) {
      final docRef = db.collection("users").doc(email);
      docRef.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          if (data["state"] != "logout") {
            Future.delayed(Duration(milliseconds: 500), () async {
              widget.handleLoginOff(true);
            });
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
