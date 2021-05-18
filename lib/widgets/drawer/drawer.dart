import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/screens/Configuration.dart';
import 'package:listadecontatos/screens/ContatoEditor.dart';
import 'package:listadecontatos/widgets/drawer/drawer_item.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context).currUser;

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              children: [
                Icon(
                  Icons.portrait_rounded,
                  size: 75,
                ),
                Text(
                  'Contatos',
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            )),
        Divider(),
        DrawerItem(
          title: Text(
            'Configurações',
            style: Theme.of(context).textTheme.headline1,
          ),
          icon: Icon(Icons.settings),
          onTap: () => Navigator.of(context).pushNamed(Configuration.routeName),
        ),
        Divider(),
        DrawerItem(
            title: Text(
              'Adicionar contato',
              style: Theme.of(context).textTheme.headline1,
            ),
            icon: Icon(Icons.person_add),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => ContatoEditor()))),
        Divider(),
        DrawerItem(
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: Colors.red),
            ),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onTap: () => Provider.of<Auth>(context, listen: false).logout()),
      ],
    ));
  }
}
