import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/widgets/misc/DateChooser.dart';
import 'package:provider/provider.dart';

class BirthdayEditor extends StatefulWidget {
  static const routeName = '';

  final Contato? initialValue;
  BirthdayEditor({this.initialValue});
  @override
  _BirthdayEditorState createState() => _BirthdayEditorState();
}

class _BirthdayEditorState extends State<BirthdayEditor> {
  Contato? c;

  void initState() {
    super.initState();

    if (widget.initialValue == null) return;

    c = widget.initialValue;
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final provider = Provider.of<Contatos>(context, listen: false);
      await provider.updateBirthday(c);
      Navigator.of(context).pop();
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data de aniversário'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildContatoChooser(),
              _mySizedBox(),
              c == null
                  ? Text('Nenhum contato escolhido')
                  : DateChooser(c?.aniversario ?? '', onChoose: (value) {
                      setState(() {
                        c?.aniversario = value;
                      });
                    }),
              _mySizedBox(),
              Center(
                child: ElevatedButton(
                    onPressed: _save, child: Text('Salvar aniversario')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _mySizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _buildContatoChooser() {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    Color borderColor = currTheme == ThemeType.light
        ? Colors.black
        : Colors.purpleAccent[100] ?? Colors.black;

    final allContatos = Provider.of<Contatos>(context).items;
    return FormField<Contato>(
      validator: (value) {
        if (value == null) return;
        return null;
      },
      onSaved: (newValue) {
        if (newValue == null) return;

        this.c = newValue;
      },
      enabled: this.c != null,
      builder: (FormFieldState<Contato> state) {
        return InputDecorator(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: borderColor,
              )),
              labelStyle: Theme.of(context).textTheme.bodyText2,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Selecione um icone para essa conta',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: this.c == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Contato>(
              value: this.c,
              isDense: true,
              onChanged: (contato) {
                setState(() {
                  this.c = contato;
                  state.didChange(contato);
                });
              },
              items: allContatos.map((value) {
                return DropdownMenuItem<Contato>(
                    value: value,
                    child: Text(
                      value.nome,
                      style: TextStyle(color: borderColor),
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
