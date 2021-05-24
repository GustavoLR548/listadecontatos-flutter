import 'package:flutter/material.dart';

const availableColors = const [
  Colors.red,
  Colors.purple,
  Colors.blue,
  Colors.amber,
  Colors.deepOrange,
  Colors.lime,
  Colors.indigo
];

class Contato with ChangeNotifier {
  final String _id;
  final String _nome;
  final String _email;
  final String _endereco;
  final String _cep;
  final String _telefone;
  String _imageFile = 'N/A';

  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone, this._imageFile);

  Color get color => availableColors[
      (this.nome.codeUnits[0] + this.nome.codeUnits[this.nome.length - 1]) %
          availableColors.length];

  String get id => this._id;

  String get nome => this._nome;

  String get email => this._email;

  String get endereco => this._endereco;

  String get cep => this._cep;

  String get telefone => this._telefone;

  String get imageFile => this._imageFile;

  bool get pathExists => this._imageFile == 'N/A';

  set imageFile(String imageFile) => this._imageFile = imageFile;

  String get initials {
    String result = '';
    var split = nome.split(' ');

    int length = split.length >= 3 ? 3 : split.length;
    for (int i = 0; i < length; i++) result += split[i][0];

    return result;
  }
}
