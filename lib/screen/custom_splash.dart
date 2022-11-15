import "package:flutter/material.dart";

class CustomSplash extends StatelessWidget {
  final bool showState;
  const CustomSplash({required this.showState, super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: showState,
      child: Container(
        color: Colors.black,
      ),
    );
  }
}
