import 'package:flutter/material.dart';

import '../Model/Conversas.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Conversa> listaConversas = [
    Conversa('Ana Clara', 'Olá tudo bem?', 'https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=bd073ee5-0112-4c99-8fd9-83d28e4efec4'),
    Conversa('Pedro Silva', 'Me manda o nome daquela série', 'https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=597e96a0-6709-4d4d-894e-60579a339fa4'),
    Conversa('Marcela Almeida', 'Vamos sair hoje?', 'https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=f944a03d-fe6f-4c30-a9a0-936c1d163f37'),
    Conversa('José Renato', 'Não vai acreditar no que tenho para te contar...', 'https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=f91eaff0-f8cb-475e-8ec3-6711616f7f43'),
    Conversa('Jamilton Damasceno', 'Curso novo!!', 'https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=25c83b65-44b6-4b48-bca2-27fce8f0d23b'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversas.length,
      itemBuilder: (context, index){
        Conversa conversa = listaConversas[index];

        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoFoto),
          ),
          title: Text(
            conversa.nome,
            style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      },
    );
  }
}


