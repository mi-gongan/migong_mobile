import "package:flutter/material.dart";

class MyPage extends StatelessWidget {
  final bool showState;
  const MyPage({required this.showState, super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: showState,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("sdfsdf"),
            Text("sdfsdf"),
            Text("sdfsdf"),
            Text("sdfsdf"),
            Text("sdfsdf"),
          ],
        ),
      ),
    );
  }
}
