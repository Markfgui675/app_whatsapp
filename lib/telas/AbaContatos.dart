import 'package:flutter/material.dart';

import '../Model/Conversas.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Conversa> listaConversas = [
    Conversa('Jose Renato', 'Olá tudo bem?', '')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ,
      itemBuilder: (context, index){

      },
    );
  }
}
