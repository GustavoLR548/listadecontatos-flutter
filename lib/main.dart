import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/screens/ContatoPage.dart';
import 'package:listadecontatos/screens/Homepage/Homepage.dart';
import 'package:listadecontatos/screens/LoginAndSignup.dart';
import 'package:listadecontatos/screens/Configuration.dart';
import 'package:listadecontatos/screens/Splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: ThemeChanger()),
        ChangeNotifierProxyProvider<Auth, Contatos>(
            create: (ctx) => Contatos(),
            update: (ctx, authData, previousContatos) =>
                Contatos.loggedIn(authData.id))
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      title: 'Educa',
      theme: theme.themeData,
      home: Consumer<Auth>(
          builder: (ctx, auth, _) => auth.isLogado
              ? Homepage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen())),
      routes: {
        Homepage.routeName: (ctx) => Homepage(),
        ContatoPage.routeName: (ctx) => ContatoPage(),
        Configuration.routeName: (ctx) => Configuration(),
      },
    );
  }
}
