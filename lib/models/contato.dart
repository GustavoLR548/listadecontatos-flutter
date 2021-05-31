import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String _aniversario;
  String _imageFile = 'N/A';

  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone, this._imageFile, this._aniversario);
  Map<String, dynamic> get toMap => {
        'phone_number': telefone,
        'name': nome,
        'email': email,
        'address': endereco,
        'cep': cep,
        'birthday': aniversario,
        'image_url': imageFile
      };

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

  String get aniversario => this._aniversario;

  String get aniversarioFormatted {
    DateTime date = DateTime.parse(this._aniversario);
    return DateFormat("dd/MM").format(date);
  }

  bool get pathExists => this._imageFile == 'N/A';

  set aniversario(String aniversario) => this._aniversario = aniversario;

  set imageFile(String imageFile) => this._imageFile = imageFile;

  String get initials {
    String result = '';
    var split = nome.split(' ');

    int length = split.length >= 3 ? 3 : split.length;
    for (int i = 0; i < length; i++) result += split[i][0];

    return result;
  }

  String get enderecoSeparado {
    String result = '';

    final split = this._endereco.split(',');

    if (split.length == 1) {
      final tmp = this._endereco.split(' ');

      String acumulator = '';
      for (String i in tmp) {
        if (acumulator.length + i.length < 33) {
          acumulator += i;
        } else {
          result += acumulator + '\n';
          acumulator = '';
        }
      }
    } else {
      int start = 0;
      int end = 33;
      while (end <= this._endereco.length) {
        result += this._endereco.substring(start, end) + '\n';
        start = end;

        if (end + 33 > this._endereco.length) {
          end = this._endereco.length;
          result += this._endereco.substring(start, end) + '\n';
          break;
        } else {
          end += 33;
        }
      }
    }

    return result;
  }
}
