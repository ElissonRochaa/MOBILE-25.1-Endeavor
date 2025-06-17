import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:endeavor/config/app_route.dart';
import 'package:endeavor/widgets/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/theme_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void loadDotEnv() async {
  await dotenv.load(fileName: "assets/.env");
}

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      loadDotEnv();
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        ErrorHandler.handleFlutterError(details.exception);
      };

      runApp(const MyApp());
    },
    (error, stackTrace) {
      ErrorHandler.handleError(error);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleIncomingLinks();
  }

  bool _handledInitialUri = false;

  void _handleIncomingLinks() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      debugPrint("Stream: ${uri.toString()}");
      if (uri != null) {
        _handleDeeplink(uri);
      }
    });

    _appLinks.getInitialAppLink().then((Uri? uri) {
      if (!_handledInitialUri) {
        debugPrint("InitialLink: ${uri.toString()}");
        if (uri != null) {
          _handleDeeplink(uri);
        }
        _handledInitialUri = true;
      }
    });
  }

  void _handleDeeplink(Uri uri) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uri.host.isNotEmpty) {
        final entidade = uri.host;
        final fullPath = uri.pathSegments.join('/');
        final rota = '/$entidade/${fullPath.isNotEmpty ? fullPath : ''}';

        final currentRoute =
            ModalRoute.of(
              navigatorKey.currentContext ?? context,
            )?.settings.name;

        debugPrint('Navegando para rota: $rota');

        if (currentRoute != rota) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            rota,
            (route) => false,
          );
        } else {
          debugPrint("Já estamos na rota: $rota");
        }
      } else {
        debugPrint('Entidade não suportada: ${uri.host}');
      }
    });
  }

  String? _extrairUri(Uri uri) {
    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments[0];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endeavor',
      navigatorKey: navigatorKey,
      theme: ThemeApp.theme,
      initialRoute: "/",
      onGenerateRoute: AppRouter.generateRoute,
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
