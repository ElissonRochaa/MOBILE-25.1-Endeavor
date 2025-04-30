
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../screens/home_screen.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            minimumSize: Size(332, 50)
          ),
            onPressed: () {
              GoogleSignIn().signIn().then((user) {
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login cancelado")),
                );
              } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(nome: user.displayName))
                );
              }
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro no login com Google")),
                );
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Image(
                    image: AssetImage("assets/googleLogo.png"),
                    height: 24.0,
                    width: 24.0
                ),
                Text("Continuar com Google", style: TextStyle(color: Colors.black,  fontSize: 20))
            ]
        )
      )
    );
  }


}