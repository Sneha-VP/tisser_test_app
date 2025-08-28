import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final prefs = GetIt.I<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1200), _decide);
  }

  void _decide() {
    final logged = prefs.getBool('isLoggedIn') ?? false;
    if (logged) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/tisser_app_logo.png',
          width: 72,
          height: 72,
        ),
      ),
    );
  }
}
