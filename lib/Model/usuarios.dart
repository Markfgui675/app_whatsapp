class Usuarios {
  String _nome = '';
  String _email = '';
  String _senha = '';
  String _urlImagem = '';

  Usuarios();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'nome': this.nome,
      'email':this.email,
      'urlImagem':this.urlImagem
    };

    return map;
  }


  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}