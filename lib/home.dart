import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp1/telas/AbaContatos.dart';
import 'package:whatsapp1/telas/AbaConversas.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  List<String> popUp = ['Configurações', 'Sair'];
  String? _email;

  _recuperarEmail() async{

    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _email = usuarioLogado.email;
    });

  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();
    if(usuarioLogado == null){
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  _escolhaMenuItem(String itemEscolhido){
    print('itemEscolhido: '+itemEscolhido);

    FirebaseAuth auth = FirebaseAuth.instance;

    switch(itemEscolhido){
      case 'Sair':
        _deslogarUsuario();
        break;
      case 'Configurações':
        Navigator.pushNamed(context, '/configuracoes');
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _recuperarEmail();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose(){
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Text('WhatsApp'),
        centerTitle: false,
        bottom: TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 5.0,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: 'Conversas',
            ),
            Tab(
              text: 'Contatos',
            )
          ],
        ),

        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return popUp.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                      child: Text(item)
                  );
                }).toList();
              }
          )
        ],
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[

          //conversas--------------------------
          AbaConversas(),

          //contatos---------------------------
          AbaContatos()
        ],
      ),
    );
  }
}
