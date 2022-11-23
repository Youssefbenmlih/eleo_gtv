// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers
// CTRL + SPACE : check possible autocompletion
// CTRL + SHIFT + R: Refactor
import 'package:flutter/material.dart';
import 'package:front/pages/home_page.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'pages/connection_page.dart';
// import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eleo_GTV',
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                color: Colors.black,
              ),
              titleSmall: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              labelMedium: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue,
          secondary: Colors.teal, // Your accent color
        ),
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
        errorColor: Colors.teal[800],
      ),
      initialRoute: "connection",
      routes: {
        "accueil": ((context) => HomePage()),
        "connection": ((context) => MyHomePage()),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final appbar = NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.indigo,
        ],
      ),
      title: Text(
          style: Theme.of(context).textTheme.titleLarge,
          "Gestion de tourets vides"),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      alignment: Alignment.topLeft,
                      icon: Icon(Icons.info),
                      title:
                          Text(style: TextStyle(color: Colors.black), "Aide"),
                      content: Text("""Veuillez entrer les identifiants qui 
vous ont été fournis, en cas de problème, contactez la logistique."""),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, "OK"),
                            child: const Text(
                                style: TextStyle(fontSize: 20), "OK")),
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                      iconColor: Colors.blue,
                    ));
          },
          icon: Icon(Icons.info),
          iconSize: 30,
        )
      ],
    );
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: appbar,
        body: Connection_page(),
      ),
    );
  }
}
