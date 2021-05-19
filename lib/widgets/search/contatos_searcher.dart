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
    return StreamBuilder<List<Contato>>(
      stream: Provider.of<Contatos>(context).fetchData(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildScaffoldBody(context, snapshot.data),
    );
  }

  buildScaffoldBody(BuildContext context, List<Contato>? contatos) {
    if (contatos != null)
      return contatos.length == 0
          ? Center(
              child: const Text(
                'Nenhum contato inserido',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: contatos.length,
                itemBuilder: (context, index) => ListTile(
                  tileColor: Theme.of(context).primaryColor,
                  leading: CircleAvatar(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(contatos[index].initials),
                    ),
                  ),
                  title: Text(contatos[index].nome),
                ),
              ),
            );
  }
}
