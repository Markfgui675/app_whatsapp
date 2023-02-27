import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp1/Model/usuarios.dart';

import 'home.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  final formKey = GlobalKey<FormState>();
  bool deuCerto = false;

  Usuarios usuario = Usuarios();

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = '';

  //método de verificação de cadastro do usuário do curso
  /*
  validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;


    if(nome.length >= 3){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length >=6){

        }else{
          setState((){
            _mensagemErro = 'Senha precisa ter mais que 6 caracteres';
          });
        }
      }else{
        setState((){
          _mensagemErro = 'Email precisa ter @';
        });
      }
    }else{
      setState(() {
        _mensagemErro = 'Nome precisa ser igual ou maior que 3 letras.';
      });
    }
  }

   */

  _cadastrarUsuario(Usuarios usario){
    
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email, password: usuario.senha
    ).then((firebaseUser) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deu certo'), backgroundColor: Colors.green,));
      deuCerto = true;
    }).catchError((error){
      print('erro:'+error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não deu certo')));
      deuCerto = false;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        backgroundColor: Color(0xff075e54),
        centerTitle: true,
      ),


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
                        child: Image.asset('imagens/usuario.png', width: 200, height: 150),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          controller: _controllerNome,
                          autofocus: true,
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
                            if(value!.length < 3){
                              return 'O nome deve ter pelo 3 caracteres';
                            }else{
                              return null;
                            }
                          },
                        ),
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
                              usuario.nome = _controllerNome.text;
                              usuario.email = _controllerEmail.text;
                              usuario.senha = _controllerSenha.text;
                              _cadastrarUsuario(usuario);
                              if(deuCerto){
                                return Home();
                              }
                            }
                          },
                          child: Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        ),

                      ),
                      Text(_mensagemErro, style: TextStyle(color: Colors.red, fontSize: 20),),
                      Center(
                        child: GestureDetector(
                          child: Text('Já tem uma conta? Entre!', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                          onTap: (){
                            Navigator.pop(context);
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
