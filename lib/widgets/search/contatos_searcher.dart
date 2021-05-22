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

  Contato? selectedContato;
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
            selectedContato = null;
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
    if (selectedContato == null)
      return Center(
        child: Text('Nenhum resultado encontrado'),
      );
    this.cp = CurrentPage.results;
    selectedContato = Provider.of<Contatos>(context, listen: false)
        .findById(selectedContato?.id ?? '');

    return ContatoInformation(selectedContato);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<Contatos>(builder: (context, contatos, child) {
      List<Contato> c;
      if (query.isNotEmpty)
        c = contatos.items
            .where((element) => element.nome.startsWith(query))
            .toList();
      else
        c = contatos.items;

      if (c.length > 0) selectedContato = c[0];
      return contatos.size == 0
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
                  itemCount: c.length,
                  itemBuilder: (context, index) =>
                      ContatoCard(Key(c[index].id), c[index], () {
                        selectedContato = c[index];
                        showResults(context);
                      })),
            );
    });
  }
}
