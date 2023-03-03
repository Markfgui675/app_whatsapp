import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp1/Model/usuarios.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  final formKey = GlobalKey<FormState>();
  Usuarios usuario = Usuarios();

  TextEditingController _controllerName = TextEditingController();
  String? _nome;
  File? _imagem;

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
    });
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
                //carregando
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/whatsapp-53c06.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=25c83b65-44b6-4b48-bca2-27fce8f0d23b'),
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
