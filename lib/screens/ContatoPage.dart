import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/widgets/contato/contato_information.dart';
import 'package:listadecontatos/widgets/misc/my_pop_menu_button.dart';
import 'package:provider/provider.dart';

class ContatoPage extends StatelessWidget {
  static const routeName = 'conta';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;

    return FutureBuilder(
        future: Provider.of<Contatos>(context).findById(id),
        builder: (context, AsyncSnapshot<Contato> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Scaffold(
              appBar: AppBar(
                title: Text('Detalhes de contato'),
                centerTitle: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          else {
            final contato = snapshot.data ?? Contato('', '', '', '', '', '');
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Detalhes de contato',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  elevation: 0,
                  centerTitle: true,
                  actions: [MyPopMenuButton(contato)],
                ),
                body: ContatoInformation(contato));
          }
        });
  }
}
