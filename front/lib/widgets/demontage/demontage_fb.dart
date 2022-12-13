// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously
import 'dart:convert';

import 'package:front/models/demontage_model.dart';
import 'package:intl/intl.dart';
import '../general/activity_summary.dart';
import 'package:flutter/material.dart';

class DemoFloatButton extends StatelessWidget {
  List<DemontageListElement> currentList;
  Function SendDemontage;
  int id;
  Object? args;
  DemoFloatButton({
    super.key,
    required this.currentList,
    required this.SendDemontage,
    required this.id,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (() async {
        if (currentList.isNotEmpty) {
          showDialog(
            context: context,
            builder: ((context) {
              return Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text("Résumé d'activité :")),
                      SizedBox(
                        height: 40,
                      ),
                      Divider(
                        color: Colors.indigo,
                        thickness: 10,
                      ),
                      ActivitySummary(
                          is_dem: true,
                          is_rec: false,
                          res: currentList.reversed.toList()),
                      Divider(
                        color: Colors.indigo,
                        thickness: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            child: Text(
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                                "REVENIR"),
                          ),
                          ElevatedButton(
                            onPressed: (() async {
                              DateTime now = DateTime.now();
                              String date =
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
                              var mod = DemontageModel(
                                  user_id: id, date: date, list: currentList);
                              String json = jsonEncode(mod);
                              int statusCode = await SendDemontage(json);
                              if (statusCode == 200) {
                                Navigator.pushNamed(context, "accueil",
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
                                      style: TextStyle(color: Colors.black),
                                      "Attention",
                                    ),
                                    content: Text(
                                        textAlign: TextAlign.center,
                                        """Une erreur est survenu vérifiez que votre liste de démontage est correcte."""),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                            style: TextStyle(fontSize: 20),
                                            "OK"),
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                    iconColor: Colors.blue,
                                  ),
                                );
                              }
                            }),
                            child: Text(
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                "TERMINER"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              alignment: Alignment.center,
              icon: Icon(color: Colors.red.shade800, Icons.warning),
              title: Text(style: TextStyle(color: Colors.black), "Attention"),
              content: Text("""Aucun démontage n'a été renseigné."""),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, "OK"),
                    child: const Text(style: TextStyle(fontSize: 20), "OK")),
              ],
              actionsAlignment: MainAxisAlignment.center,
              iconColor: Colors.blue,
            ),
          );
        }
      }),
      label: Text(
        style: Theme.of(context).textTheme.titleLarge,
        "Confirmer",
      ),
      icon: Icon(Icons.arrow_circle_right),
      backgroundColor: Colors.green,
    );
  }
}
