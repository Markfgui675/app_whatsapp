import 'package:flutter/material.dart';
import 'package:whatsapp1/Model/usuarios.dart';
import 'package:whatsapp1/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();

  Usuarios usuario = Usuarios();


  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  _logarUsuario(Usuarios usuario){
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sucesso no login'),
        backgroundColor: Colors.green,));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível fazer o seu login, '
          'verifique o email e senha e tente novamente'), backgroundColor: Colors.red,));
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if(usuarioLogado != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: Image.asset('imagens/logo.png', width: 200, height: 150),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                hintText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                )
                            ),
                            validator: (value){
                              if(value!.contains('@')){
                                return null;
                              }else{
                                return 'O email deve ter o @!';
                              }
                            },
                          ),
                        ),
                        TextFormField(
                          controller: _controllerSenha,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          style: TextStyle(fontSize: 20),
                          validator: (value){
                            if(value!.length <= 6){
                              return 'A senha deve ter mais que 6 caracteres';
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: 'Senha',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 32),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)
                                )
                            ),
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                usuario.email = _controllerEmail.text;
                                usuario.senha = _controllerSenha.text;
                                _logarUsuario(usuario);
                              }
                            },
                            child: Text('Entrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          ),

                        ),
                        Center(
                          child: GestureDetector(
                            child: Text('Não tem uma conta? Cadastre-se', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
                            },
                          ),
                        )
                      ],
                    ),
                  ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
