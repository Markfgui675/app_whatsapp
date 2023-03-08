import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/Conversas.dart';
import '../Model/usuarios.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  String? _idusuarioLogado;
  String? _emailusuarioLogado;

  Future<List<Usuarios>> _recuperarContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection('usuarios').getDocuments();

    List<Usuarios> listaUsuarios = [];
    for (DocumentSnapshot item in querySnapshot.documents){

      var dados = item.data;

      if(dados['email']== _emailusuarioLogado) continue;

      Usuarios usuario = Usuarios();
      usuario.email = dados['email'];
      usuario.nome = dados['nome'];
      usuario.urlImagem = dados['urlImagem'];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idusuarioLogado = usuarioLogado.uid;
    _emailusuarioLogado = usuarioLogado.email;

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuarios>>(
      future: _recuperarContatos(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Carregando contatos...'),
                    SizedBox(height: 20),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index){

                  List<Usuarios> listaItens = snapshot.data!;
                  Usuarios usuario = listaItens[index];

                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/mensagens', arguments: usuario);
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      usuario.urlImagem == ''
                          ?  null
                          :  NetworkImage(usuario.urlImagem)
                    ),
                    title: Text(
                      usuario.nome,
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                },
              );
              break;
          }
        }
    );
  }
}


