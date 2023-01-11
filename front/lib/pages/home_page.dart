// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable, prefer_const_declarations, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/general/gradient_elevated.dart';
import '../widgets/general/navigation_drawer.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:flutter/services.dart';
import '../globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future sendEmail({
    required Map resume_stock_enedis,
    required String date,
  }) async {
    final serviceId = 'service_yao7rvc';
    final templateId = 'template_69f751q';
    final publicKey = 'rbU3sx4543Co0rMQp';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-type': 'application/json'
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'resume_stock_enedis': resume_stock_enedis.toString(),
            'date': date,
          }
        }));
  }

  int _selectedIndex = 0;
  String url_h = getIp();
  Future<Map> fetchStock() async {
    final response = await http.get(Uri.parse('$url_h/api/enedis/list'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then return
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get stock');
    }
  }

  bool b = true;

  void showDialogMultiple(title, msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.topLeft,
        icon: Icon(Icons.warning),
        title: Text(style: TextStyle(color: Colors.black), "$title"),
        content: Text(textAlign: TextAlign.center, """$msg"""),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "REVENIR"),
            child: const Text(
              style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              "REVENIR",
            ),
          ),
          TextButton(
            onPressed: () async {
              b = false;
              var now = DateTime.now();
              String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
              var stock_enedis = await fetchStock();
              var mail = await sendEmail(
                resume_stock_enedis: stock_enedis,
                date: date.toString(),
              );
            },
            child: const Text(
              style: TextStyle(fontSize: 20),
              "OK",
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        iconColor: Colors.red.shade800,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromARGB(255, 139, 139, 139),
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_sharp),
                label: 'Gestion Tourets Vides',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.place_rounded),
                label: 'Placements Enedis',
                backgroundColor: Colors.red,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ),
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
                  _selectedIndex == 0
                      ? Column(children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.document_scanner_outlined,
                                    size: 35,
                                  ),
                                  Spacer(),
                                  Text(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.handyman_outlined,
                                    size: 35,
                                  ),
                                  Spacer(),
                                  Text(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.fire_truck,
                                    size: 35,
                                  ),
                                  Spacer(),
                                  Text(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.table_view_sharp,
                                    size: 35,
                                  ),
                                  Spacer(),
                                  Text(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    'Inventaire Tourets V.',
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ])
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: MyElevatedButton(
                                height: 80,
                                width: 350,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "Enedis",
                                    arguments: perma_args,
                                  );
                                },
                                borderRadius: BorderRadius.circular(40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 35,
                                    ),
                                    Spacer(),
                                    Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      'Emplacement Enedis',
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: MyElevatedButton(
                                height: 80,
                                width: 350,
                                onPressed: () async {
                                  showDialogMultiple(
                                    "Attention",
                                    "Êtes-vous sûr de l'envoi du mail?",
                                  );
                                  if (!b) {
                                    Navigator.pop(context, "OK");
                                    b = true;
                                  }
                                },
                                borderRadius: BorderRadius.circular(40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 35,
                                    ),
                                    Spacer(),
                                    Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      "Envoyer Mail Infos",
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
