import 'package:flutter/material.dart';

import 'Model/usuarios.dart';

class Mensagens extends StatefulWidget {
  Usuarios contato;
  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  
  TextEditingController _mensagemController = TextEditingController();

  _enviarMensagem(){

  }

  _enviarFoto(){

  }

  @override
  Widget build(BuildContext context) {

    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextField(
              controller: _mensagemController,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                hintText: 'Mensagem',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32)
                ),
                prefixIcon: IconButton(
                  onPressed: (){_enviarFoto();},
                  icon: Icon(Icons.camera_alt, color: Color(0xff075e54),)
                ),
              ),
            ),
          )),
          FloatingActionButton(
              onPressed: (){_enviarMensagem();},
            backgroundColor: Color(0xff075e54),
            child: Icon(Icons.send, color: Colors.white,),
            mini: true,
          )
        ],
      ),
    );












    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Text(widget.contato.nome),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('imagens/bg.png'), fit: BoxFit.cover)
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text('listview'),
                caixaMensagem
                //listview
                //caixa de mensagem
              ],
            ),
          )
        ),
      )
    );
  }
}
