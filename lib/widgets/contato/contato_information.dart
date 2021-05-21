import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';

class ContatoInformation extends StatelessWidget {
  final Contato selectedContato;
  const ContatoInformation(this.selectedContato);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        children: [
          Hero(
            tag: selectedContato.id,
            child: CircleAvatar(
                backgroundColor: selectedContato.color,
                radius: 50,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    selectedContato.initials.toUpperCase(),
                    style: TextStyle(fontSize: 36),
                  ),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(selectedContato.telefone,
              style: Theme.of(context).textTheme.headline1),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              selectedContato.email,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              selectedContato.cep,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
