import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
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
          future: Provider.of<Contatos>(context).fetchData(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Contatos>(
                      builder: (context, contatos, child) => contatos.size == 0
                          ? Center(
                              child: const Text(
                                'Nenhum contato inserido',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : GroupedListView<Contato, String>(
                              elements: contatos.items,
                              groupBy: (element) => element.nome[0],
                              groupSeparatorBuilder: (groupByValue) =>
                                  Text(groupByValue),
                              itemBuilder: (context, element) => ListTile(
                                leading: CircleAvatar(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(element.initials),
                                  ),
                                ),
                                title: Text(element.nome),
                              ),
                              itemComparator: (item1, item2) => item1.nome[0]
                                  .compareTo(item2.nome[0]), // optional
                              useStickyGroupSeparators: true, // optional
                              floatingHeader: true, // optional
                            ),
                    ),
        ));
  }
}
