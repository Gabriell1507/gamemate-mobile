import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gamemate/core/services/auth_service.dart';
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
  int _getIndexByRoute(String? route) {
    switch (route) {
      case '/friends':
        return 0;
      case '/library':
        return 1; // antes era 1
      case '/home':
        return 2; // antes era 2
      // case '/stats':
      //   return 3;
      case '/profile':
        return 3; // antes era 4
      default:
        return 2; // padrão Home
    }
  }

  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    final currentRoute = Get.currentRoute;
    selectedIndex = _getIndexByRoute(currentRoute);
  }

  Future<void> onTabChange(int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        final authService = Get.find<AuthService>();
        await authService.signOut();
        Get.offAllNamed('/login');
        break;

      case 1:
        Get.offNamed('/library');
        break;
      case 2:
        Get.offNamed('/home');
        break;
      // case 3:
      //   Get.offAllNamed('/login');
      //   break;
      case 3:
        Get.offNamed('/profile');
        break;
      default:
        Get.offNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TabItem> items = [
      const TabItem(icon: Icons.group, title: 'Amigos'),
      const TabItem(icon: Icons.library_books, title: 'Biblioteca'),
      const TabItem(icon: Icons.home, title: 'Home'),
      // const TabItem(icon: Icons.bar_chart, title: 'Estatística'),
      const TabItem(icon: Icons.person, title: 'Perfil'),
    ];

    return BottomBarDefault(
      indexSelected: selectedIndex,
      onTap: onTabChange,
      color: Colors.white70,
      colorSelected: Colors.white,
      backgroundColor:Colors.transparent,
      animated: true,
      items: items,
    );
  }
}
