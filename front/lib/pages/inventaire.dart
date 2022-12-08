// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:front/models/inventaire_model.dart';
import 'package:front/widgets/gradient_elevated.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../globals.dart';
import '../widgets/my_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class Inventaire extends StatefulWidget {
  const Inventaire({super.key});

  @override
  State<Inventaire> createState() => _InventaireState();
}

class _InventaireState extends State<Inventaire> {
  void wipeClean() {
    setState(() {});
  }

  String url_h = getIp();

  Future<int> SendInventaire(content) async {
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/inventaire'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: content,
    );

    if (resp.statusCode == 200) {
      setState(() {
        // var j = jsonDecode(resp.body);
      });
    } else {
      setState(() {});
    }
    return resp.statusCode;
  }

  Future<Map> fetchStock() async {
    final response = await http.get(Uri.parse('$url_h/api/stock/get'));

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

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  bool isSwitchedCercle = false;
  bool isSwitchedDemonte = false;
  bool isValide = false;

  int current_stock_value = 0;

  TextEditingController numberTouretsText = TextEditingController();

  Map data = {
    'G': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'H': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'I': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
  };

  bool b = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    var id = mapArgs['id'];

    while (!b) {
      fetchStock().then((value) {
        setState(
          () {
            data = value;
          },
        );
      });
      b = true;
    }

    String currentSelectedTouret =
        "Touret $dropdownValue ${isSwitchedDemonte ? "Démonté" : "Monté"} ${isSwitchedCercle ? "Cerclé" : "Non Cerclé"} : (Stock actuel : $current_stock_value)";
    current_stock_value = data[dropdownValue.length != 1 ? 'G' : dropdownValue][
        "stock_${isSwitchedDemonte ? "de" : ""}monte_${isSwitchedCercle ? "" : "non_"}cercle"];

    return Scaffold(
      appBar: MyAppBar(wipeClean, "Inventaire", args, true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                  style: Theme.of(context).textTheme.headlineMedium,
                  "Type Touret:"),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              alignment: Alignment.center,
              child: DropdownButton<String>(
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                    isValide = false;
                  });
                },
                items: list.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          style: Theme.of(context).textTheme.headlineMedium,
                          "Cerclé : "),
                      Spacer(
                        flex: 2,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: isSwitchedCercle,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedCercle = value;
                              isValide = false;
                            });
                          },
                        ),
                      ),
                      Spacer(
                        flex: 5,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        style: Theme.of(context).textTheme.headlineMedium,
                        "Démonté : ",
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: isSwitchedDemonte,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedDemonte = value;
                              isValide = false;
                            });
                          },
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            MyElevatedButton(
              onPressed: (() {
                if (dropdownValue.length == 1) {
                  setState(() {
                    isValide = true;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.topLeft,
                      icon: Icon(Icons.warning),
                      title: Text(
                          style: TextStyle(color: Colors.black), "Attention"),
                      content: Text(
                          textAlign: TextAlign.center,
                          """Veuillez saisir un type de touret"""),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, "OK"),
                            child: const Text(
                                style: TextStyle(fontSize: 20), "OK")),
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                      iconColor: Colors.red.shade800,
                    ),
                  );
                }
              }),
              width: 200,
              borderRadius: BorderRadius.circular(30),
              child: Text(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  "Valider"),
            ),
            isValide
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          style: Theme.of(context).textTheme.labelLarge,
                          currentSelectedTouret,
                        ),
                      ),
                      SizedBox(height: 50),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headlineLarge,
                            "Entrez la nouvelle valeur de stock : ",
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        height: 70,
                        margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                        alignment: Alignment.center,
                        child: NumberInputPrefabbed.squaredButtons(
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          controller: numberTouretsText,
                          incDecBgColor: Colors.blueAccent,
                          min: 0,
                          max: 2000,
                          initialValue: current_stock_value,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      MyElevatedButton(
                        onPressed: (() {
                          setState(
                            () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  alignment: Alignment.center,
                                  icon: Icon(Icons.warning),
                                  title: Text(
                                      style: TextStyle(color: Colors.black),
                                      "Envoi d'inventaire"),
                                  content: Text(
                                      textAlign: TextAlign.center,
                                      """Êtes-vous sûr de vos modifications ?"""),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "ANNULER"),
                                      child: const Text(
                                          style: TextStyle(fontSize: 20),
                                          "ANNULER"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.red.shade800, // Text Color
                                      ),
                                      onPressed: () async {
                                        DateTime now = DateTime.now();
                                        String date =
                                            DateFormat('dd/MM/yyyy HH:mm:ss')
                                                .format(now);
                                        var inventaire = InventaireModel(
                                          user_id: id,
                                          date: date,
                                          type_touret: dropdownValue,
                                          nb_monte_cercle: isSwitchedCercle &&
                                                  !isSwitchedDemonte
                                              ? (int.parse(numberTouretsText
                                                          .text) -
                                                      data[dropdownValue][
                                                          "stock_monte_cercle"])
                                                  .toInt()
                                              : 0,
                                          nb_demonte_cercle: isSwitchedCercle &&
                                                  isSwitchedDemonte
                                              ? (int.parse(numberTouretsText
                                                          .text) -
                                                      data[dropdownValue][
                                                          "stock_demonte_cercle"])
                                                  .toInt()
                                              : 0,
                                          nb_monte_non_cercle: !isSwitchedCercle &&
                                                  !isSwitchedDemonte
                                              ? (int.parse(numberTouretsText
                                                          .text) -
                                                      data[dropdownValue][
                                                          "stock_monte_non_cercle"])
                                                  .toInt()
                                              : 0,
                                          nb_demonte_non_cercle:
                                              !isSwitchedCercle &&
                                                      isSwitchedDemonte
                                                  ? (int.parse(numberTouretsText
                                                              .text) -
                                                          data[dropdownValue][
                                                              "stock_demonte_non_cercle"])
                                                      .toInt()
                                                  : 0,
                                          stock_avant: current_stock_value,
                                          stock_apres:
                                              int.parse(numberTouretsText.text),
                                        );
                                        String json = jsonEncode(inventaire);
                                        int statusCode =
                                            await SendInventaire(json);
                                        if (statusCode == 200) {
                                          Navigator.pushNamed(
                                              context, "accueil",
                                              arguments: args);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              alignment: Alignment.center,
                                              icon: Icon(
                                                color: Colors.red.shade800,
                                                Icons.warning,
                                              ),
                                              title: Text(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                "Attention",
                                              ),
                                              content: Text(
                                                  textAlign: TextAlign.center,
                                                  """Une erreur est survenu"""),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text(
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                      "OK"),
                                                ),
                                              ],
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              iconColor: Colors.blue,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                          style: TextStyle(fontSize: 20),
                                          "OUI"),
                                    ),
                                  ],
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  iconColor: Colors.red.shade800,
                                ),
                              );
                            },
                          );
                        }),
                        height: 70,
                        borderRadius: BorderRadius.circular(30),
                        width: 300,
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 97, 191, 102),
                          Colors.green,
                          Color.fromARGB(255, 97, 191, 102),
                        ]),
                        child: Text(
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          "Confirmer",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
