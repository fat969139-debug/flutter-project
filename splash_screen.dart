import 'dart:async';//لاستخدام المؤقت
import 'package:flutter/material.dart';// المكتبة الاساسية لتصميم الواجهات
import 'package:lottie/lottie.dart';
import 'package:netflix_app/Screen/app_navbar_screen.dart';//استدعاء الصفحة اللي بتنتقل اليها

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppNavbarScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/netflix.json"));
  }
}
