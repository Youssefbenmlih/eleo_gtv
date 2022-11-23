// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar(this.refreshPage, this.title, {super.key});

  final String title;

  final Function refreshPage;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.indigo,
        ],
      ),
      leading: BackButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              alignment: Alignment.topLeft,
              icon: Icon(Icons.warning),
              title: Text(style: TextStyle(color: Colors.black), "Quitter"),
              content: Text(
                  """Êtes-vous sûr de vouloir quitter la page ? Toutes vos modifications seront perdues."""),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, "ANNULER"),
                  child: const Text(style: TextStyle(fontSize: 20), "ANNULER"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade800, // Text Color
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "accueil");
                  },
                  child: const Text(style: TextStyle(fontSize: 20), "OUI"),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
              iconColor: Colors.red.shade800,
            ),
          );
          // refreshPage();
          // Navigator.pop(context);
        },
        color: Colors.white,
      ),
      centerTitle: true,
      title: Text(style: Theme.of(context).textTheme.titleLarge, title),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                alignment: Alignment.topLeft,
                icon: Icon(Icons.logout),
                title:
                    Text(style: TextStyle(color: Colors.black), "Déconnexion"),
                content:
                    Text("""Êtes-vous sûr de vouloir vous déconnecter ?"""),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, "ANNULER"),
                    child:
                        const Text(style: TextStyle(fontSize: 20), "ANNULER"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade800, // Text Color
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "connexion");
                    },
                    child: const Text(style: TextStyle(fontSize: 20), "OUI"),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.spaceBetween,
                iconColor: Colors.red.shade800,
              ),
            );
          },
        ),
      ],
    );
  }
}
