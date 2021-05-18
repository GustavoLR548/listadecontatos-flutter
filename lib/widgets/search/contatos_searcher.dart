import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:provider/provider.dart';

class ContatoSearcher extends SearchDelegate<Contato> {
  @override
  String get searchFieldLabel => 'Pesquisar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<Contatos>(
      builder: (context, contatos, child) => ListView.builder(
        itemCount: contatos.size,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.portrait),
          title: Text(contatos.items[index].nome),
        ),
      ),
    );
  }
}
