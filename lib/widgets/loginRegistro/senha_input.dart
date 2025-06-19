import 'package:flutter/material.dart';

class InputSenha extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;

  const InputSenha({
    super.key,
    required this.controller,
    required this.label,
    this.hint = "exemplo12345",
    this.validator,
  });

  @override
  State<InputSenha> createState() => _InputSenhaState();
}

class _InputSenhaState extends State<InputSenha> {
  bool _esconderSenha = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _esconderSenha,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _esconderSenha = !_esconderSenha;
              });
            },
            icon: Icon(
              _esconderSenha
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF03045E),
            ),
          ),
        ),
        style: const TextStyle(fontSize: 20),
        validator: widget.validator,
      ),
    );
  }
}
