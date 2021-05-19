import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/screens/contato_page.dart';
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
        body: StreamBuilder<List<Contato>>(
          stream: Provider.of<Contatos>(context).fetchData(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : buildScaffoldBody(context, snapshot.data),
        ));
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
              child: GroupedListView<Contato, String>(
                elements: contatos,
                groupBy: (element) => element.nome[0],
                groupSeparatorBuilder: (groupByValue) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    groupByValue,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                itemBuilder: (context, element) => ListTile(
                  onTap: () async {
                    final result = await Navigator.of(context)
                        .pushNamed(ContaPage.routeName, arguments: element);

                    await Future.delayed(Duration(milliseconds: 600));
                    if (result == null) return;
                    if (result == 'delete')
                      Provider.of<Contatos>(context, listen: false)
                          .remove(element.id);
                  },
                  tileColor: Theme.of(context).primaryColor,
                  leading: CircleAvatar(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(element.initials),
                    ),
                  ),
                  title: Text(element.nome),
                ),
                itemComparator: (item1, item2) =>
                    item1.nome[0].compareTo(item2.nome[0]), // optional
                useStickyGroupSeparators: true, // optional
                floatingHeader: true, // optional
              ),
            );
  }
}
