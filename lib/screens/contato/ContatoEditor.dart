import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/widgets/imagePicker/pick_user_image.dart';
import 'package:listadecontatos/widgets/misc/DateChooser.dart';
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
  bool updateContato = false;

  final int _minTitleLength = 3;

  void initState() {
    if (widget.contato == null) {
      _formData = {
        'name': '',
        'email': '',
        'Endereco': '',
        'cep': '',
        'phone_number': '',
        'birthday': ''
      };
    } else {
      _addressController.text = widget.contato?.endereco ?? '';

      if (!(widget.contato?.pathExists ?? false))
        _formData['image_path'] = widget.contato?.imageFile ?? '';
      updateContato = true;
      _formData.addAll({
        'name': widget.contato?.nome ?? '',
        'email': widget.contato?.email ?? '',
        'address': _addressController.text,
        'cep': widget.contato?.cep ?? '',
        'phone_number': widget.contato?.telefone ?? '',
        'birthday': widget.contato?.aniversario ?? ''
      });
    }
    super.initState();
  }

  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  void _storeUserImageFile(String image) {
    _formData['image_path'] = image;
  }

  _save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final provider = Provider.of<Contatos>(context, listen: false);
      if (updateContato) {
        provider.update(
            Contato(
                widget.contato?.id ?? '',
                _formData['name'] ?? '',
                _formData['email'] ?? '',
                _formData['address'] ?? '',
                _formData['cep'] ?? '',
                _formData['phone_number'] ?? '',
                widget.contato?.imageFile ?? '',
                _formData['birthday'] ?? ''),
            File(_formData['image_path'] ?? ''));
      } else {
        provider.add(
          _formData['name'] ?? '',
          _formData['email'] ?? '',
          _formData['address'] ?? '',
          _formData['cep'] ?? '',
          _formData['phone_number'] ?? '',
          _formData['birthday'] ?? '',
          File(_formData['image_path'] ?? ''),
        );
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
                  initialValue: _formData['image_path'],
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
                DateChooser(
                  _formData['birthday'] ?? '',
                  onChoose: (value) {
                    setState(() {
                      _formData['birthday'] = value;
                    });
                  },
                ),
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

  SizedBox _mySizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _buildNameTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['name'],
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
          _formData['name'] = '';
          return;
        }
        _formData['name'] = value.trim();
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

  Widget _buildPhoneNumberTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['phone_number'],
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
          _formData['phone_number'] = '';
          return;
        }
        _formData['phone_number'] = value.trim();
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

  Widget _buildEmailTFF(Color borderColor, BuildContext context) {
    return TextFormField(
      initialValue: _formData['email'],
      decoration: InputDecoration(
          icon: Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(5.0)),
          labelText: 'email',
          counterStyle: Theme.of(context).textTheme.bodyText1,
          labelStyle: Theme.of(context).textTheme.bodyText2),
      maxLength: 50,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        if (value == null) {
          _formData['email'] = '';
          return;
        }
        _formData['email'] = value.trim();
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

  Widget _buildAddressTFF(Color borderColor, BuildContext context) {
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
          _formData['address'] = '';
          return;
        }
        _formData['address'] = value.trim();
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

  Widget _buildCepTFF(BuildContext ctx, Color borderColor) {
    return TextFormField(
      initialValue: _formData['cep'],
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
          _formData['cep'] = '';
          return;
        }
        _formData['cep'] = value.trim();
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
          _formData['address'] = _addressController.text;
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
