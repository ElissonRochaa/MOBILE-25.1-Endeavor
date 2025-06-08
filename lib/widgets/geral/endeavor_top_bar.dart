import 'package:endeavor/screens/home_screen.dart';
import 'package:endeavor/screens/perfil_screen.dart';
import 'package:flutter/material.dart';

import '../../config/theme_app.dart';

class EndeavorTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hideLogo;
  final IconButton? icone;

  const EndeavorTopBar({
    super.key,
    required this.title,
    this.hideLogo = false,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          hideLogo
              ? BackButton(color: Theme.of(context).colorScheme.onPrimary)
              : IconButton(
                icon: Image(
                  image: AssetImage("assets/flameLogo.png"),
                  height: 48,
                  width: 60,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child:
              icone ??
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  );
                },
                icon: Icon(Icons.account_circle, color: Colors.white),
                iconSize: 36,
              ),
        ),
      ],
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'BebasNeue',
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
      centerTitle: false,
      backgroundColor: ThemeApp.theme.colorScheme.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 68,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
