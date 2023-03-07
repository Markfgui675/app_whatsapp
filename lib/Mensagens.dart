import 'package:flutter/material.dart';

import 'Model/usuarios.dart';

class Mensagens extends StatefulWidget {
  Usuarios contato;
  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Text(widget.contato.nome),
      ),
      body: Container(),
    );
  }
}
