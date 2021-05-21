import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/widgets/contato/contato_card.dart';
import 'package:listadecontatos/widgets/contato/contato_information.dart';
import 'package:listadecontatos/widgets/misc/my_pop_menu_button.dart';
import 'package:provider/provider.dart';

enum CurrentPage { suggestions, results }

class ContatoSearcher extends SearchDelegate<Contato> {
  @override
  String get searchFieldLabel => 'Pesquisar';

  late Contato selectedContato;
  CurrentPage cp = CurrentPage.suggestions;

  @override
  List<Widget> buildActions(BuildContext context) {
    return cp == CurrentPage.results
        ? [MyPopMenuButton(selectedContato)]
        : [
            IconButton(
                onPressed: () {
                  query = '';
                },
                icon: Icon(Icons.clear))
          ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (cp == CurrentPage.results) {
            cp = CurrentPage.suggestions;
            showSuggestions(context);
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

//ContatoInformation(selectedContato)
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Contatos>(context).findById(selectedContato.id),
        builder: (context, AsyncSnapshot<Contato> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : ContatoInformation(selectedContato));
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
              : buildScaffoldBody(context, snapshot.data ?? []),
    );
  }

  buildScaffoldBody(BuildContext context, List<Contato> contatos) {
    if (query.isNotEmpty)
      contatos =
          contatos.where((element) => element.nome.startsWith(query)).toList();
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
                itemBuilder: (context, index) =>
                    ContatoCard(Key(contatos[index].id), contatos[index], () {
                      this.cp = CurrentPage.results;
                      selectedContato = contatos[index];
                      showResults(context);
                    })),
          );
  }
}
