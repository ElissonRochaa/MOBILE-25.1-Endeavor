import 'package:flutter/material.dart';

import '../config/themeApp.dart';
import '../widgets/loginRegistro/linha_widget.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SecondLoginScreen extends StatelessWidget {
  const SecondLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Image(image: AssetImage("assets/flameLogo.png"),
                height: 160,
                width: 200,
                alignment: Alignment.center),
            Text("Endeavor",
                style: TextStyle(fontSize: 48, fontFamily: 'BebasNeue')
            ),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                obscuringCharacter: '*',
                style: TextStyle(fontSize: 20),
                controller: TextEditingController(),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    minimumSize: Size(332, 50)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }, child: Text('Entrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
            ),
            Container(
                margin: const EdgeInsets.only(left: 40, right: 40, top: 25, bottom: 25),
                child: LinhaWidget("ou")
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    minimumSize: Size(332, 50)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }, child: Text('Voltar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
            ),
          ],
        ),
      ),
    );
  }
}