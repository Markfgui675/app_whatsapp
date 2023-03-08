import 'package:flutter/material.dart';

import 'Model/usuarios.dart';

class Mensagens extends StatefulWidget {
  Usuarios contato;
  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  Usuarios usuario = Usuarios();

  List<String> listaMensagen = [
    'Olá meu amigo, tudo bem?',
    'Tudo! E contigo?',
    'Estou muito bem! Queria ver uma coisa contigo',
    'Não sei'
  ];
  TextEditingController _mensagemController = TextEditingController();

  _enviarMensagem(){
    String textoMensagen = _mensagemController.text;
    if(textoMensagen.isNotEmpty){

    }
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



  var listView = Expanded(
      child: ListView.builder(
        itemCount: listaMensagen.length,
          itemBuilder: (context, index){
          
          double larguraContainer = MediaQuery.of(context).size.width * 0.8;

          //Define cores e alinhamentos
            Alignment alinhamento = Alignment.centerRight;
            Color cor = Color(0xffd2ffa5);
            if(index % 2 == 0){
              alinhamento = Alignment.centerRight;
              cor = Color(0xffd2ffa5);
            } else {
              alinhamento = Alignment.centerLeft;
              cor = Colors.white;
            }

            return Align(
              alignment: alinhamento,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: larguraContainer,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Text(listaMensagen[index], style: TextStyle(fontSize: 16),),
                ),
              ),
            );
          },
      )
  );







    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage:
              widget.contato.urlImagem == ''
              ?  null
              :  NetworkImage(widget.contato.urlImagem)
            ),
            SizedBox(width: 12),
            Text(widget.contato.nome)
          ]
        ),
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

                listView,

                caixaMensagem

              ],
            ),
          )
        ),
      )
    );
  }
}
