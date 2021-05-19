import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/screens/ContatoEditor.dart';

class ContaPage extends StatelessWidget {
  static const routeName = 'conta';
  @override
  Widget build(BuildContext context) {
    final contato = ModalRoute.of(context)?.settings.arguments as Contato;

    return Scaffold(
      appBar: AppBar(
        title: Text(contato.nome),
        elevation: 0,
        centerTitle: true,
        actions: [_buildPopMenuButton(context, contato)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: contato.id,
              child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 50,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(contato.initials),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(contato.telefone,
                style: Theme.of(context).textTheme.headline1),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                contato.email,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                contato.cep,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopMenuButton(BuildContext context, Contato contato) {
    return PopupMenuButton(
      color: Theme.of(context).accentColor,
      onSelected: (String value) {
        if (value == 'edit') {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => ContatoEditor(contato: contato),
          ));
        } else if (value == 'delete') {
          Navigator.of(context).pop('delete');
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
