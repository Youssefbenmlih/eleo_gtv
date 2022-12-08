// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, camel_case_types, no_leading_underscores_for_local_identifiers, unused_element
import 'package:front/globals.dart';
import 'package:flutter/material.dart';
import '../widgets/general/gradient_elevated.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class Connection_page extends StatefulWidget {
  const Connection_page({super.key});

  @override
  State<Connection_page> createState() => _Connection_page();
}

class _Connection_page extends State<Connection_page> {
  bool loginfail = false;
  bool loginsucces = false;
  bool _passwordVisible = false;

  final EmailController = TextEditingController();

  final PasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();

    late String userName;
    late int id;

    @override
    void dispose() {
      // Clean up the focus node when the Form is disposed.
      myFocusNode.dispose();

      super.dispose();
    }

    Future<int> VerifyUser(String email, String password) async {
      String url_h = getIp();
      final resp = await http.post(
        Uri.parse('$url_h/api/users/connect'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, String>{"email": email, "mot_de_passe": password}),
      );

      if (resp.statusCode == 200) {
        setState(() {
          var j = jsonDecode(resp.body);
          userName = j['name'];
          id = j['id'];
          loginsucces = true;
          loginfail = false;
        });
      } else {
        setState(() {
          loginsucces = false;
          loginfail = true;
        });
      }
      return resp.statusCode;
    }

    void submit_data() async {
      if (EmailController.text.isNotEmpty &&
          PasswordController.text.isNotEmpty) {
        await VerifyUser(EmailController.text, PasswordController.text);
        if (loginsucces) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "accueil",
                  arguments: {'name': userName, 'id': id})
              .then((_) => setState(() {}));
        }
      }
    }

    return SingleChildScrollView(
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
                  fit: BoxFit.contain,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: TextField(
                focusNode: null,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                ),
                controller: EmailController,
                onSubmitted: (_) {
                  if (PasswordController.text.isEmpty) {
                    myFocusNode.requestFocus();
                  } else {
                    submit_data();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "nom@email.com ou nom.prenom",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
            child: loginfail
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 2, 0, 0),
                    child: Text(
                      style: TextStyle(color: Color.fromARGB(255, 158, 45, 37)),
                      'Email ou mot de passe erroné, veuillez ressaisir.',
                    ),
                  )
                : null,
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
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
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
                focusNode: myFocusNode,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                controller: PasswordController,
                onSubmitted: (_) {
                  submit_data();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                    hintText: "mot de passe",
                    suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        })),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: loginfail
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 2, 0, 0),
                    child: Text(
                      style: TextStyle(color: Color.fromARGB(255, 158, 45, 37)),
                      'Email ou mot de passe erroné, veuillez ressaisir.',
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyElevatedButton(
              height: 100,
              onPressed: () {
                submit_data();
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
    );
  }
}
