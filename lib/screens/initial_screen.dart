import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:endeavor/models/auth_response.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/screens/home_screen.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:endeavor/services/auth_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class InitialScreen extends ConsumerStatefulWidget {
  const InitialScreen({super.key});

  @override
  ConsumerState<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {
  double _opacity = 1.0;
  bool? isAuthenticated;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // Animação do texto
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _opacity = 0.0;
      });
    });

    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    isAuthenticated = await _authenticationCheck();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _loading = false;
    });
  });
  }

  Future<bool> _authenticationCheck() async {
    bool value = await AuthStorageService().isAuthenticated();

    if (value) {
      String? id = await AuthStorageService().getId();
      String? token = await AuthStorageService().getToken();
      ref.watch(authProvider.notifier).setAuth(AuthResponse(id: id, token: token));
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  duration: const Duration(milliseconds: 1200),
                  opacity: _opacity,
                  child: const Text(
                    "Endeavor",
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'BebasNeue',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        nextScreen: isAuthenticated!
            ? const HomeScreen()
            : const LoginScreen(),
        animationDuration: const Duration(milliseconds: 2200),
        splashIconSize: 400,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        duration: 2400,
      ),
    );
  }
}