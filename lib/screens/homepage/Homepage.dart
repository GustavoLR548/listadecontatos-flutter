import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/screens/contato/ContatoPage.dart';
import 'package:listadecontatos/widgets/contato/contato_card.dart';
import 'package:listadecontatos/widgets/drawer/drawer.dart';
import 'package:listadecontatos/widgets/search/contatos_searcher.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';

class Homepage extends StatelessWidget {
  static const routeName = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seus contatos'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ContatoSearcher());
              },
              icon: Icon(Icons.search),
              color: Colors.black,
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Contatos>(context, listen: false).fetchData(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : buildScaffoldBody(context),
        ));
  }

  buildScaffoldBody(BuildContext context) {
    return Consumer<Contatos>(
        builder: (context, contatos, child) => contatos.size == 0
            ? Center(
                child: const Text(
                  'Nenhum contato inserido',
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GroupedListView<Contato, String>(
                  elements: contatos.items,
                  groupBy: (element) => element.nome[0],
                  groupSeparatorBuilder: (groupByValue) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      groupByValue.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  itemBuilder: (context, element) =>
                      ContatoCard(Key(element.nome), element, () async {
                    await Navigator.of(context).pushNamed(ContatoPage.routeName,
                        arguments: element.id);
                  }),
                  itemComparator: (item1, item2) =>
                      item1.nome[0].compareTo(item2.nome[0]), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, // optional
                ),
              ));
  }
}
