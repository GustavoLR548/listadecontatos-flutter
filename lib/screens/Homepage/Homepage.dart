import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/widgets/drawer/drawer.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  static const routeName = '/homepage';
  @override
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context).currUser;

    return Scaffold(
        appBar: AppBar(
          title: Text('ta aqui'),
          centerTitle: true,
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
                      builder: (context, value, child) => ListView.builder(
                        itemCount: value.size,
                        itemBuilder: (context, index) =>
                            Text(value.items[index].nome),
                      ),
                    ),
        ));
  }
}
