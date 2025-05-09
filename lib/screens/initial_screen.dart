import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _opacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Center(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animation.json"),
              Positioned(
                left: 120,
                bottom: 30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: _opacity,
                  child: Text(
                    "Endeavor",
                    style: TextStyle(fontSize: 48, fontFamily: 'BebasNeue'),
                  ),
                ),
              ),
            ],
          ),
        ),
        nextScreen: LoginScreen(),
        animationDuration: const Duration(milliseconds: 2200),
        splashIconSize: 400,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        duration: 2400,
      ),
    );
  }
}
