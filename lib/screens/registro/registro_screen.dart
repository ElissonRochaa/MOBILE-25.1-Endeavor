import 'package:endeavor/screens/home_screen.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool esconderSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Image(
                image: AssetImage("assets/flameLogo.png"),
                height: 160,
                width: 200,
              ),
              Text(
                "ENDEAVOR",
                style: TextStyle(
                    fontSize: 48,
                    fontFamily: "BebasNeue",
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Cadastre-se",
                style: TextStyle(fontSize: 24),
              ),
              //email
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "exemplo@gmail.com",
                    hintStyle: TextStyle(color: Colors.black54),
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            emailController.text = "";
                          });
                        },
                        icon: Icon(Icons.clear)
                    )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              //senha
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: TextField(
                    controller: senhaController,
                    decoration: InputDecoration(
                        labelText: "Senha",
                        hintText: "exemplo12345",
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                esconderSenha = !esconderSenha;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye_outlined)
                        )
                    ),
                    obscureText: esconderSenha,
                    style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 40),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      fixedSize: Size(
                          MediaQuery.sizeOf(context).width,
                          50),
                      backgroundColor: Theme.of(context).primaryColor
                    ),
                    child: Text(
                      "Registrar",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Text(
                      "Já possui conta? "
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4)
                        ),
                        child: Text(
                          "Faça o login!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
