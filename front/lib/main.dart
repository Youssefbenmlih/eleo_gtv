// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers
// CTRL + SPACE : check possible autocompletion
// CTRL + SHIFT + R: Refactor
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'widgets/gradient_elevated.dart';
import 'pages/second_page.dart';
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
      home: MyHomePage(),
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
    final EmailController = TextEditingController();

    final PasswordController = TextEditingController();

    FocusNode myFocusNode = FocusNode();

    @override
    void dispose() {
      // Clean up the focus node when the Form is disposed.
      myFocusNode.dispose();

      super.dispose();
    }

    void _submitUserInfo() {
      if (EmailController.text.isNotEmpty &&
          PasswordController.text.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return SecondPage(title: EmailController.text);
          }),
        ).then((_) => setState(() {}));
      }
    }

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
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 36, 18, 18),
              child: SizedBox(
                  height: 150,
                  width: 100,
                  child: Image.asset(
                    "assets/images/logo_eleo.png",
                    fit: BoxFit.none,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Text(
                "Email - Nom d'utilisateur:",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                  ),
                  controller: EmailController,
                  onSubmitted: (_) {
                    _submitUserInfo();
                    myFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "nom@email.com ou nom.prenom",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Text(
                "Mot de passe:",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  ),
                  focusNode: myFocusNode,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: PasswordController,
                  onSubmitted: (_) => {_submitUserInfo()},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "mot de passe",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyElevatedButton(
                height: 100,
                onPressed: () {
                  if (EmailController.text.isNotEmpty &&
                      PasswordController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SecondPage(title: EmailController.text);
                      }),
                    ).then((_) => setState(() {}));
                  }
                },
                borderRadius: BorderRadius.circular(40),
                child: Text(
                    style: Theme.of(context).textTheme.titleLarge, 'CONNEXION'),
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
