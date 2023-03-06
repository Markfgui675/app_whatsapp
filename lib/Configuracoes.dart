import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp1/Model/usuarios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  final formKey = GlobalKey<FormState>();
  Usuarios usuario = Usuarios();
  String? _nomeusuarioLogado;
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;

  TextEditingController _controllerName = TextEditingController();
  String? _idusuarioLogado;
  File? _imagem;
  File? imagemSelecionada;

  Future? _recuperarImagem(String origemImagem) async {

    File? imagemSelecionada;
    switch(origemImagem){
      case 'camera':
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        //imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 'galeria':
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
    .child('perfil')
    .child('${_idusuarioLogado}.jpg');
    
    //Upload de imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if(storageEvent.type == SystemMouseCursors.progress){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });

  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);
    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      'urlImagem':url
    };

    db.collection('usuarios')
    .document(_idusuarioLogado)
    .updateData(dadosAtualizar);
  }
  
  _atualizarDadosUsuario(String name) async {
    Firestore db = Firestore.instance;
    db.collection('usuarios')
    .document(_idusuarioLogado)
    .setData({
      'nome':name
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idusuarioLogado = usuarioLogado.uid;
    DocumentSnapshot snapshot = await db.collection('usuarios')
        .document(_idusuarioLogado)
        .get();//recupera os dados do usuário específicos

    Map<String, dynamic> dados = snapshot.data;
    _controllerName.text = dados['nome'];

    if(dados['urlImagem'] != null){

      _urlImagemRecuperada = dados['urlImagem'];

    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Text('Configurações'),
      ),
      body: Container(
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                _subindoImagem
                ? CircularProgressIndicator()
                : Container(),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: _urlImagemRecuperada != null
                    ? NetworkImage(_urlImagemRecuperada!)
                    : null
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _recuperarImagem('camera');
                      },
                      child: Text('Câmera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Color(0xff075e54))),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap:(){
                        _recuperarImagem('galeria');
                      },
                      child: Text('Galeria', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Color(0xff075e54))),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _controllerName,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: 'Nome',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )
                  ),
                  validator: (value){
                    if(value!.length >= 1){
                      return null;
                    }else{
                      return 'Coloque um nome!';
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      _atualizarDadosUsuario(_controllerName.text);
                    }
                  },
                  child: Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
