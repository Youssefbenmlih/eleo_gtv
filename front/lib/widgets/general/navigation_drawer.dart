// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var args;

  NavigationDrawerWidget({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.cyan.shade50,
                  Colors.indigo.shade100
                ]),
          ),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 88,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo,
                        Colors.cyan,
                      ],
                    ),
                    color: Colors.blue,
                  ),
                  child: Text(
                      style: Theme.of(context).textTheme.titleLarge,
                      "Naviguation"),
                ),
              ),
              Card(
                elevation: 8,
                child: ListTile(
                  tileColor: Colors.white,
                  iconColor: Colors.blue,
                  trailing: Icon(Icons.folder),
                  title: const Text(
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      'Historique'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "historique",
                      arguments: args,
                    );
                  },
                ),
              ),
              Card(
                elevation: 8,
                child: ListTile(
                  tileColor: Colors.white,
                  iconColor: Colors.blue,
                  trailing: Icon(Icons.table_chart_sharp),
                  title: const Text(
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      'Stock'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "stock",
                      arguments: args,
                    );
                  },
                ),
              ),
              Card(
                elevation: 8,
                child: ListTile(
                  tileColor: Colors.white,
                  iconColor: Colors.blue,
                  trailing: Icon(Icons.info),
                  title: const Text(
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      'Aide'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              alignment: Alignment.topLeft,
                              icon: Icon(Icons.info),
                              title: Text(
                                  style: TextStyle(color: Colors.black),
                                  "Aide"),
                              content: Text(
                                  textAlign: TextAlign.center,
                                  """Naviguez ici dans les differentes activités, infos et stock reliés
aux tourets vides. Pour plus d'informations contactez la logistique."""),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, "OK"),
                                    child: const Text(
                                        style: TextStyle(fontSize: 20), "OK")),
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                              iconColor: Colors.blue,
                            ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}