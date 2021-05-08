import 'package:flutter/material.dart';
import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/screens/Homepage/Perfil.dart';
import 'package:listadecontatos/widgets/drawer/drawer.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int? _selectedPageIndex;

  void initState() {
    _selectedPageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context).currUser;
    List<Map<String, dynamic>> _pages;
    _pages = [
      {
        'page': Perfil(
            userData['username'], userData['email'], userData['image_url']),
        'title': 'Perfil'
      },
      {
        'page': Perfil(
            userData['username'], userData['email'], userData['image_url']),
        'title': 'Perfil'
      },
      {
        'page': Perfil(
            userData['username'], userData['email'], userData['image_url']),
        'title': 'Perfil'
      }
    ];

    int index = _selectedPageIndex ?? 0;
    return DefaultTabController(
      length: _pages.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text('ta aqui'),
            centerTitle: true,
          ),
          drawer: AppDrawer(),
          body: _pages[index]['page'],
          bottomSheet: TabBar(
            onTap: (int index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            tabs: [
              Tab(
                text: _pages[0]['title'],
              ),
              Tab(
                text: _pages[1]['title'],
              ),
              Tab(
                text: _pages[2]['title'],
              )
            ],
          )),
    );
  }
}
