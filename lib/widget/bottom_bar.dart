import "package:flutter/material.dart";

class BottomBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final int selectedIndex;

  const BottomBar(
      {required this.onTap, required this.selectedIndex, super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'movie'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'mypage'),
        ],
        currentIndex: widget.selectedIndex,
        iconSize: 32,
        showSelectedLabels: false,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          opacity: 1,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
          opacity: 0.5,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
