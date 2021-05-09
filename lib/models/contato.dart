import 'package:flutter/cupertino.dart';

class Contato with ChangeNotifier {
  String _creatorId;
  String _nome;
  String _email;
  String _endereco;
  String _cep;
  String _telefone;

  Contato(this._creatorId, this._nome, this._email, this._endereco, this._cep,
      this._telefone);

  String get creatorId {
    return this._creatorId;
  }

  set creatorId(String creatorId) {
    this._creatorId = creatorId;
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
