import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/widgets/imagePicker/pick_user_image.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, File imageFile, BuildContext ctx) _submitData;

  final bool _isLoading;

  AuthForm(this._submitData, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formValues = {
    'email': '',
    'username': '',
    'password': '',
  };

  final placeholder = File('assets/images/icon.jpg');

  String? _userImageFile;
  var _isLogin = true;

  //Functions

  void _storeUserImageFile(String image) {
    _userImageFile = image;
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (!isValid || (_userImageFile == null && !_isLogin)) {
      String errorMessageContent = _userImageFile == null && !_isLogin
          ? 'Nenhum imagem foi provida'
          : 'Credencias de usuário inválida';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessageContent),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    _formKey.currentState?.save();

    widget._submitData(
        _formValues['email']?.trim() ?? '',
        _formValues['password']?.trim() ?? '',
        _formValues['username']?.trim() ?? '',
        _isLogin,
        File(_userImageFile ?? ''),
        ctx);
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    Widget confirmButton = (widget._isLoading)
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: OutlinedButton(
                child: Text(_isLogin ? 'Entrar' : 'Inscrever-se'),
                onPressed: () => _trySubmit(context)));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      constraints: BoxConstraints(minHeight: _isLogin ? 360 : 530),
      height: _isLogin ? 360 : 530,
      child: Card(
        color: currTheme == ThemeType.light ? Colors.white : Colors.black45,
        margin: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (_isLogin)
                  Text(
                    'Entrar',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                if (!_isLogin) PickUserImage(_storeUserImageFile),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  initialValue: _formValues['email'],
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null)
                      return 'O valor inserido não pode ser nulo';

                    if (value.isEmpty || !_isValidEmail(value))
                      return 'Please enter a valid email address';
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _formValues['email'] = value;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    initialValue: _formValues['username'],
                    decoration: InputDecoration(labelText: 'Nome de usuário'),
                    validator: (value) {
                      String result;
                      if (value == null)
                        return 'O valor inserido não pode ser nulo';
                      result = value;

                      if (result.isEmpty || result.length < 4)
                        return 'O usuário precisa ter no mínimo 4 caractéres';
                      return null;
                    },
                    onSaved: (value) {
                      _formValues['username'] = value ?? '';
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  initialValue: _formValues['password'],
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null)
                      return 'O valor inserido não pode ser nulo';

                    if (value.isEmpty || value.length < 7)
                      return 'A senha deve ter no mínimo 7 caractéres';
                    return null;
                  },
                  onSaved: (value) {
                    _formValues['password'] = value ?? '';
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                confirmButton,
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: ElevatedButton(
                    child: Text(_isLogin ? 'Criar nova conta' : 'Fazer Login'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
