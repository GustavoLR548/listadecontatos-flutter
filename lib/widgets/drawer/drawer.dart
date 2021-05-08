import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/widgets/drawer/drawer_item.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text(
            'Educa',
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        DrawerItem(
          title: Text(
            'Configurações',
            style: Theme.of(context).textTheme.headline1,
          ),
          icon: Icon(Icons.settings),
          onTap: () {},
        ),
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
          onTap: () {
            print('saiu');
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    ));
  }
}
