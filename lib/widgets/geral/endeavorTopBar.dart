import 'package:endeavor/screens/homeScreen.dart';
import 'package:flutter/material.dart';

import '../../config/themeApp.dart';

class EndeavorTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const EndeavorTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Image(image: AssetImage("assets/flameLogo.png"),
            height: 48,
            width: 60,
            alignment: Alignment.centerLeft),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }),
      title: Text(title,
          style: TextStyle(fontSize: 28, fontFamily: 'BebasNeue', color: Colors.white),
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