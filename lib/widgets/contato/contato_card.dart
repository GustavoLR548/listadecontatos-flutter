import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';

const availableColors = const [
  Colors.red,
  Colors.black,
  Colors.purple,
  Colors.blue
];

class ContatoCard extends StatelessWidget {
  final Contato contato;
  final Function onTap;
  const ContatoCard(
    Key key,
    this.contato,
    this.onTap,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Hero(
        tag: contato.id,
        child: CircleAvatar(
          backgroundColor: contato.color,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(contato.initials.toUpperCase()),
          ),
        ),
      ),
      title: Text(
        contato.nome,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
