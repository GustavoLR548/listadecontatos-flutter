import 'package:flutter/cupertino.dart';

class Contato with ChangeNotifier {
  int _id;
  String _nome;
  String _email;
  String _endereco;
  String _cep;
  String _telefone;

  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone);

  int get id {
    return this._id;
  }

  set id(int id) {
    this._id = id;
  }

  String get nome {
    return this._nome;
  }

  set nome(String nome) {
    this._nome = nome;
  }

  String get email {
    return this._email;
  }

  set email(String email) {
    this._email = email;
  }

  String get endereco {
    return this._endereco;
  }

  set endereco(String endereco) {
    this._endereco = endereco;
  }

  String get cep {
    return this._cep;
  }

  set cep(String cep) {
    this._cep = cep;
  }

  String get telefone {
    return this._telefone;
  }

  set telefone(String telefone) {
    this._telefone = telefone;
  }
}
