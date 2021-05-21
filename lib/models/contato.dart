import 'package:flutter/material.dart';

const availableColors = [Colors.red, Colors.black, Colors.purple, Colors.blue];

class Contato with ChangeNotifier {
  String _id = '';
  String _nome = '';
  String _email = '';
  String _endereco = '';
  String _cep = '';
  String _telefone = '';

  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone);

  Contato.froJson(Map<String, dynamic> json, String id) {
    this._id = id;
    this._telefone = json['phone_number'];
    this._nome = json['name'];
    this._email = json['email'];
    this._endereco = json['address'];
    this._cep = json['cep'];
  }

  Color get color =>
      availableColors[this.nome.codeUnits[0] % availableColors.length];

  String get id => this._id;

  set id(String id) => this._id = id;

  String get nome => this._nome;

  set nome(String nome) => this._nome = nome;

  String get email => this._email;

  set email(String email) => this._email = email;

  String get endereco => this._endereco;

  set endereco(String endereco) => this._endereco = endereco;

  String get cep => this._cep;

  set cep(String cep) => this._cep = cep;

  String get telefone => this._telefone;

  set telefone(String telefone) => this._telefone = telefone;

  String get initials {
    String result = '';
    var split = nome.split(' ');

    int length = split.length >= 3 ? 3 : split.length;
    for (int i = 0; i < length; i++) result += split[i][0];

    return result;
  }
}
