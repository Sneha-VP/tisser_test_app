import 'package:flutter/material.dart';
import '../views/item_details_screen.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/home_screen.dart';
import '../views/item_list_screen.dart';
import '../views/item_edit_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String items = '/items';
  static const String itemDetail = '/item_detail';
  static const String itemEdit = '/item_edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case items:
        return MaterialPageRoute(builder: (_) => const ItemListScreen());
      case itemDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: args?['id']));
      case itemEdit:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ItemEditScreen(item: args?['item']));
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('No route'))));
    }
  }
}
