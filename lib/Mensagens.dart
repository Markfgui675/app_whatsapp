import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp1/Model/Mensagem.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'Model/usuarios.dart';

class Mensagens extends StatefulWidget {
  Usuarios contato;
  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  Usuarios usuario = Usuarios();
  Firestore db = Firestore.instance;
  String? _idusuarioLogado;
  String? _idusuarioDestinatario;
  File? _imagem;
  bool _subindoImagem = false;
  TextEditingController _mensagemController = TextEditingController();

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idusuarioLogado =
        usuarioLogado.uid; //recupera os dados do usuário específicos
    _idusuarioDestinatario = widget.contato.idUsuario;
  }

  _enviarMensagem() {
    String textoMensagen = _mensagemController.text;
    if (textoMensagen.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idusuarioLogado!;
      mensagem.mensagem = textoMensagen;
      mensagem.urlImagem = '';
      mensagem.tipo = 'texto';

      _salvarMensagem(_idusuarioLogado!, _idusuarioDestinatario!, mensagem);
      _salvarMensagem(_idusuarioDestinatario!, _idusuarioLogado!, mensagem);
    }
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection('mensagens')
        .document(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    _mensagemController.clear();

    /*
    +mensagens
      +jamilton
        +aluno
          +identificadorFirebase
            <Mensagem>
     */
  }

  _enviarFoto() async {
    File? imagemSelecionada;
    imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    _subindoImagem = true;
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child('mensagens')
        .child(_idusuarioLogado)
        .child('${_idusuarioLogado}.jpg');

    //Upload de imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == SystemMouseCursors.progress) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });


    @override
    void initState() {
      super.initState();
      _recuperarDadosUsuario();
    }

    @override
    //Widget build(BuildContext context) {}

      /*
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

   */



  @override
  Widget build(BuildContext context) {

    var caixaMensagem = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: TextField(
                  controller: _mensagemController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    hintText: 'Mensagem',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: IconButton(
                        onPressed: _enviarFoto,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Color(0xff075e54),
                        )),
                  ),
                ),
              )),
          FloatingActionButton(
            onPressed: () {
              _enviarMensagem();
            },
            backgroundColor: Color(0xff075e54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: db
          .collection('mensagens')
          .document(_idusuarioLogado)
          .collection(_idusuarioDestinatario)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Carregando mensagens...'),
                  SizedBox(height: 20),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot? querySnapshot = snapshot.data;
            print('tô aqui');
            return Expanded(
                child: ListView.builder(
                  itemCount: querySnapshot!.documents.length,
                  itemBuilder: (context, index) {
                    //recupera mensagem
                    List<DocumentSnapshot> mensagens =
                    querySnapshot.documents.toList();
                    DocumentSnapshot item = mensagens[index];

                    double larguraContainer =
                        MediaQuery.of(context).size.width * 0.8;

                    //Define cores e alinhamentos
                    Alignment alinhamento = Alignment.centerRight;
                    Color cor = const Color(0xffd2ffa5);
                    if (_idusuarioLogado != item['idUsuario']) {
                      alinhamento = Alignment.centerLeft;
                      cor = Colors.white;
                    } else {
                      alinhamento = Alignment.centerRight;
                      cor = Color(0xffd2ffa5);
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Text(
                            item['mensagem'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ));
            break;
        }
      },
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
                    backgroundImage: widget.contato.urlImagem == ''
                        ? null
                        : NetworkImage(widget.contato.urlImagem)),
                SizedBox(width: 12),
                Text(widget.contato.nome)
              ]),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('imagens/bg.png'), fit: BoxFit.cover)),
          child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[stream, caixaMensagem],
                ),
              )),
        ));

  }
}}
