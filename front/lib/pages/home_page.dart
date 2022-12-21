// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import '../widgets/general/gradient_elevated.dart';
import '../widgets/general/navigation_drawer.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  HomePage();

  late Object perma_args;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      perma_args = args;
    }

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final appbar = NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.indigo,
        ],
      ),
      centerTitle: true,
      title: Text(style: Theme.of(context).textTheme.titleLarge, "ACCUEIL"),
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
                alignment: Alignment.topRight,
                icon: Icon(Icons.logout),
                title:
                    Text(style: TextStyle(color: Colors.black), "Déconnexion"),
                content: Text(
                    textAlign: TextAlign.center,
                    """Êtes-vous sûr de vouloir vous déconnecter ?"""),
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

    return WillPopScope(
      onWillPop: () async {
        return !Navigator.of(context).userGestureInProgress;
      },
      child: Scaffold(
        drawer: NavigationDrawerWidget(
          args: args,
        ),
        appBar: appbar,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                    "Choisissez votre activité :",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyElevatedButton(
                      height: 80,
                      width: 350,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "reception",
                          arguments: perma_args,
                        );
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.document_scanner_outlined,
                            size: 35,
                          ),
                          Spacer(),
                          Text(
                            style: Theme.of(context).textTheme.titleLarge,
                            'Réception Tourets V.',
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyElevatedButton(
                      height: 80,
                      width: 350,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "demontage",
                          arguments: perma_args,
                        );
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.handyman_outlined,
                            size: 35,
                          ),
                          Spacer(),
                          Text(
                            style: Theme.of(context).textTheme.titleLarge,
                            'Démontage Tourets',
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyElevatedButton(
                      height: 80,
                      width: 350,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "chargement",
                          arguments: perma_args,
                        );
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.fire_truck,
                            size: 35,
                          ),
                          Spacer(),
                          Text(
                            style: Theme.of(context).textTheme.titleLarge,
                            'Chargement Joues',
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyElevatedButton(
                      height: 80,
                      width: 350,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "inventaire",
                          arguments: perma_args,
                        );
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.table_view_sharp,
                            size: 35,
                          ),
                          Spacer(),
                          Text(
                            style: Theme.of(context).textTheme.titleLarge,
                            'Inventaire Tourets V.',
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
