import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/widgets/misc/circle_fade_in_avatar.dart';

const availableColors = const [
  Colors.red,
  Colors.black,
  Colors.purple,
  Colors.blue
];

class ContatoCard extends StatelessWidget {
  final Contato contato;
  final bool showBirthday;
  final Function onTap;
  const ContatoCard(Key key, this.contato, this.onTap,
      {this.showBirthday = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Hero(
        tag: contato.id,
        child: !contato.pathExists
            ? CircleFadeInAvatar(
                contato.imageFile,
                size: 50,
              )
            : CircleAvatar(
                backgroundColor: contato.color,
                radius: 25,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(contato.initials.toUpperCase()),
                ),
              ),
      ),
      title: Text(
        contato.nome,
      ),
      subtitle: Text(
        this.showBirthday
            ? this.contato.aniversarioFormatted
            : this.contato.telefone,
      ),
    );
  }
}
