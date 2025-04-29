import 'package:endeavor/screens/loginScreen.dart';
import 'package:flutter/material.dart';

import 'config/themeApp.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endeavor',
      theme: ThemeApp.theme,
      home: //const DismissKeyboard(child: MateriasScreen()),
          const DismissKeyboard(child: LoginScreen()),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
