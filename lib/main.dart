import 'dart:async';

import 'package:endeavor/screens/initial_screen.dart';
import 'package:endeavor/widgets/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/themeApp.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void loadDotEnv() async {
  await dotenv.load(fileName: "assets/.env");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadDotEnv();
  runZonedGuarded(
    () {
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        ErrorHandler.handleFlutterError(details.exception);
      };

      runApp(MyApp());
    },
    (error, stackTrace) {
      ErrorHandler.handleError(error);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endeavor',
      navigatorKey: navigatorKey,
      theme: ThemeApp.theme,
      home: const DismissKeyboard(child: InitialScreen()),
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
