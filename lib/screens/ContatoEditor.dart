import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/widgets/misc/pick_user_image.dart';
import 'package:provider/provider.dart';
import 'package:via_cep_flutter/via_cep_flutter.dart';

class ContatoEditor extends StatefulWidget {
  final Contato? contato;

  ContatoEditor({this.contato});
  @override
  _ContatoEditorState createState() => _ContatoEditorState();
}

class _ContatoEditorState extends State<ContatoEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _addressController = TextEditingController();
  Map<String, String> _formData = {};
  File? _userImageFile;
  bool updateContato = false;

  final int _minTitleLength = 3;

  void initState() {
    if (widget.contato == null) {
      _formData = {
        'Name': '',
        'Email': '',
        'Endereco': '',
        'Cep': '',
        'Phone_number': '',
      };
    } else {
      _addressController.text = widget.contato?.endereco ?? '';

      if (!(widget.contato?.pathExists ?? false))
        _userImageFile = File(widget.contato?.imageFile ?? '');
      updateContato = true;
      _formData = {
        'Name': widget.contato?.nome ?? '',
        'Email': widget.contato?.email ?? '',
        'Address': _addressController.text,
        'Cep': widget.contato?.cep ?? '',
        'Phone_number': widget.contato?.telefone ?? '',
      };
    }
    super.initState();
  }

  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  void _storeUserImageFile(File image) {
    _userImageFile = image;
  }

  _save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final provider = Provider.of<Contatos>(context, listen: false);
      if (updateContato) {
        provider.update(
            Contato(
                widget.contato?.id ?? '',
                _formData['Name'] ?? '',
                _formData['Email'] ?? '',
                _formData['Address'] ?? '',
                _formData['Cep'] ?? '',
                _formData['Phone_number'] ?? '',
                widget.contato?.imageFile ?? ''),
            _userImageFile ?? File(''));
      } else {
        provider.add(
            _formData['Name'] ?? '',
            _formData['Email'] ?? '',
            _formData['Address'] ?? '',
            _formData['Cep'] ?? '',
            _formData['Phone_number'] ?? '',
            _userImageFile ?? File(''));
      }
      Navigator.of(context).pop();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    Color borderColor = currTheme == ThemeType.light
        ? Colors.black
        : Colors.purpleAccent[100] ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(updateContato ? 'Atualizando contato' : 'Novo contato'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ListView(
              children: [
                _mySizedBox(),
                PickUserImage(
                  _storeUserImageFile,
                  imageSource: ImageSource.gallery,
                  initialValue: _userImageFile,
                ),
                _mySizedBox(),
                _buildNameTFF(borderColor, context),
                _mySizedBox(),
                _buildPhoneNumberTFF(borderColor, context),
                _mySizedBox(),
                _buildEmailTFF(borderColor, context),
                _mySizedBox(),
                _buildCepTFF(context, borderColor),
                _mySizedBox(),
                _buildAddressTFF(borderColor, context),
                _mySizedBox(),
                Center(
                  child: ElevatedButton(
                      onPressed: _save, child: Text('Salvar Contato')),
                ),
              ],
            ),
          )),
    );
  }

  _mySizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  _buildNameTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['Name'],
      maxLength: 20,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5.0)),
        counterStyle: Theme.of(context).textTheme.bodyText1,
        labelText: 'Nome',
        labelStyle: Theme.of(context).textTheme.bodyText2,
      ),
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value == null) {
          _formData['Name'] = '';
          return;
        }
        _formData['Name'] = value.trim();
      },
      validator: (value) {
        if (value == null) return 'O valor não pode ser null';
        if (value.isEmpty) {
          return 'O \'Nome\' não deveria estar vazio';
        } else if (value.length < _minTitleLength) {
          return 'O \'Nome\' não deveria ter no mínimo $_minTitleLength caracteres ';
        }
        return null;
      },
    );
  }

  _buildPhoneNumberTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['Phone_number'],
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
        icon: Icon(Icons.phone),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5.0)),
        labelText: 'Telefone',
        labelStyle: Theme.of(context).textTheme.bodyText2,
      ),
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        if (value == null) {
          _formData['Phone_number'] = '';
          return;
        }
        _formData['Phone_number'] = value.trim();
      },
      validator: (value) {
        if (value == null) return 'o valor não pode ser nulo';
        if (value.isEmpty) {
          return 'O \'Cep\' não deveria ser vazio';
        }
        return null;
      },
    );
  }

  _buildEmailTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['Email'],
      decoration: InputDecoration(
          icon: Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(5.0)),
          labelText: 'Email',
          counterStyle: Theme.of(context).textTheme.bodyText1,
          labelStyle: Theme.of(context).textTheme.bodyText2),
      maxLength: 50,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        if (value == null) {
          _formData['Email'] = '';
          return;
        }
        _formData['Email'] = value.trim();
      },
      validator: (value) {
        if (value == null) return 'o valor não pode ser nulo';
        if (value.isEmpty) {
          return 'O \'Email\' não deveria ser vazio';
        } else if (!_isValidEmail(value)) return 'Este não é um email válido';
        return null;
      },
    );
  }

  _buildAddressTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      controller: _addressController,
      maxLines: 3,
      decoration: InputDecoration(
        icon: Icon(Icons.location_city),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5.0)),
        labelText: 'Endereço',
        labelStyle: Theme.of(context).textTheme.bodyText2,
      ),
      keyboardType: TextInputType.streetAddress,
      onSaved: (value) {
        if (value == null) {
          _formData['Address'] = '';
          return;
        }
        _formData['Address'] = value.trim();
      },
      validator: (value) {
        if (value == null) return 'o valor não pode ser nulo';
        if (value.isEmpty) {
          return 'O \'valor\' não deveria ser vazio';
        }
        return null;
      },
    );
  }

  _buildCepTFF(BuildContext ctx, Color borderColor) {
    return TextFormField(
      initialValue: _formData['Cep'],
      decoration: InputDecoration(
        icon: Icon(Icons.add_location_rounded),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5.0)),
        labelText: 'CEP',
        labelStyle: Theme.of(context).textTheme.bodyText2,
      ),
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 8,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        if (value == null) {
          _formData['Cep'] = '';
          return;
        }
        _formData['Cep'] = value.trim();
      },
      onChanged: (value) async {
        if (value.length != 8) return;

        final result = await readAddressByCep(value);

        if (result.isEmpty) {
          showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
              title: Text('Atenção!'),
              content: Text('Este CEP é inválido!'),
            ),
          );
          return;
        }

        setState(() {
          _addressController.text =
              result['street'] + ', ' + result['city'] + ', ' + result['state'];
          _formData['Address'] = _addressController.text;
        });
      },
      validator: (value) {
        if (value == null) return 'o valor não pode ser nulo';
        if (value.isEmpty) {
          return 'O \'Cep\' não deveria ser vazio';
        }
        return null;
      },
    );
  }
}
