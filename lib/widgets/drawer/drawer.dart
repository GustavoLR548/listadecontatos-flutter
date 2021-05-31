import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/screens/Configuration.dart';
import 'package:listadecontatos/screens/contato/birthday/BirthdayScaffold.dart';
import 'package:listadecontatos/screens/contato/ContatoEditor.dart';
import 'package:listadecontatos/widgets/drawer/drawer_item.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currTheme =
        Provider.of<ThemeChanger>(context, listen: false).currTheme;

    final iconColor =
        currTheme == ThemeType.light ? Colors.black : Colors.white;
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
                  color: iconColor,
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
          icon: Icon(
            Icons.settings,
            color: iconColor,
          ),
          onTap: () => Navigator.of(context).pushNamed(Configuration.routeName),
        ),
        Divider(),
        DrawerItem(
            title: Text(
              'Adicionar contato',
              style: Theme.of(context).textTheme.headline1,
            ),
            icon: Icon(
              Icons.person_add,
              color: iconColor,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => ContatoEditor()))),
        Divider(),
        DrawerItem(
            title: Text(
              'Aniversariantes',
              style: Theme.of(context).textTheme.headline1,
            ),
            icon: Icon(
              Icons.calendar_today_sharp,
              color: iconColor,
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(BirthdayScaffold.routeName)),
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
