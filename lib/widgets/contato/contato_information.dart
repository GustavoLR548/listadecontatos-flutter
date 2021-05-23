import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/widgets/misc/icontext.dart';

class ContatoInformation extends StatelessWidget {
  final Contato? selectedContato;
  const ContatoInformation(this.selectedContato);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 35, bottom: 25),
          child: Hero(
            tag: selectedContato?.id ?? '',
            child: CircleAvatar(
                backgroundColor: selectedContato?.color ?? Colors.black,
                radius: deviceSize.width / 5,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    selectedContato?.initials.toUpperCase() ?? '',
                    style: TextStyle(fontSize: 36),
                  ),
                )),
          ),
        ),
        Text(
          selectedContato?.nome ?? '',
          style: Theme.of(context).textTheme.headline3,
        ),
        Divider(
          color: Colors.white,
        ),
        _buildSizedBox(),
        IconText(selectedContato?.telefone ?? '', Icons.phone),
        _buildSizedBox(),
        IconText(selectedContato?.email ?? '', Icons.email),
        _buildSizedBox(),
        IconText(selectedContato?.endereco ?? '', Icons.location_city),
      ],
    );
  }

  _buildSizedBox() {
    return const SizedBox(
      height: 10,
    );
  }
}
