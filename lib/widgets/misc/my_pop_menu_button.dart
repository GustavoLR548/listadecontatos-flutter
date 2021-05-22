import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/screens/ContatoEditor.dart';
import 'package:provider/provider.dart';

class MyPopMenuButton extends StatelessWidget {
  final Contato? contato;
  MyPopMenuButton(this.contato);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).accentColor,
      onSelected: (String value) async {
        if (value == 'edit') {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => ContatoEditor(contato: contato),
          ));
        } else if (value == 'delete') {
          await Provider.of<Contatos>(context, listen: false)
              .remove(contato?.id ?? '');
          Navigator.of(context).pop();
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.border_color,
                color: Colors.black,
              ),
              const SizedBox(
                width: 5,
              ),
              Text('Editar')
            ],
          ),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          value: 'delete',
        ),
      ],
    );
  }
}
