import "package:flutter/material.dart";

class CustomSplash extends StatelessWidget {
  final bool offstage;
  const CustomSplash({required this.offstage, super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: offstage,
      child: Container(
        color: Colors.black,
      ),
    );
  }
}
