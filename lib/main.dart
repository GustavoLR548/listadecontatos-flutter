import 'package:listadecontatos/provider/auth.dart';
import 'package:listadecontatos/provider/themes.dart';
import 'package:listadecontatos/screens/LoginAndSignup.dart';
import 'package:listadecontatos/screens/Configuration.dart';
import 'package:listadecontatos/screens/Homepage/HomepageTabController.dart';
import 'package:listadecontatos/screens/Splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return snapshot.connectionState != ConnectionState.done
            ? SplashScreen()
            : MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: Auth()),
                  ChangeNotifierProvider.value(value: ThemeChanger())
                ],
                child: MyMaterialApp(),
              );
      },
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
        Configuration.routeName: (ctx) => Configuration(),
      },
    );
  }
}
