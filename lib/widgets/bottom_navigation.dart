import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomBar({
    super.key,
    this.initialIndex = 2, // padrão Home
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void onTabChange(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.toNamed('/login');
        break;
      case 1:
        Get.toNamed('/login');
        break;
      case 2:
        Get.toNamed('/home');
        break;
      case 3:
        Get.toNamed('/login');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
      default:
        Get.toNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TabItem> items = [
      TabItem(icon: Icons.group, title: 'Amigos'),
      TabItem(icon: Icons.library_books, title: 'Biblioteca'),
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.bar_chart, title: 'Estatística'),
      TabItem(icon: Icons.person, title: 'Perfil'),
    ];

    return BottomBarDefault(
      indexSelected: selectedIndex,
      onTap: onTabChange,
      color: Colors.white70,
      colorSelected: Colors.white,
      backgroundColor: const Color(0xFF0E2D57),
      animated: true,
      items: items,
    );
  }
}
