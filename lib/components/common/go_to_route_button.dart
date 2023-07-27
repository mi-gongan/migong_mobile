import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GoToRouteButton extends StatelessWidget {
  const GoToRouteButton(
      {super.key, required this.text, required this.routeName});

  final String text;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: Text(text),
        onPressed: () {
          Navigator.of(context).pushNamed(routeName);
          debugPrint('Open Route \'$routeName\'');
        },
      ),
    );
  }
}
