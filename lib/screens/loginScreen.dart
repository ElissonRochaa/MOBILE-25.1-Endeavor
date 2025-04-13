import 'dart:ui';

import 'package:endeavor/screens/secondLoginScreen.dart';
import 'package:endeavor/widgets/linhaWidget.dart';
import 'package:flutter/material.dart';

import '../config/themeApp.dart';
import '../widgets/googleSignInButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                  MaterialPageRoute(builder: (context) => const SecondLoginScreen()),
                );
              }, child: Text('Continuar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
              ),
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, top: 25, bottom: 25),
                child: LinhaWidget("ou")
              ),
              GoogleSignInButton()
            ],
          ),
        ),
      );
  }
}