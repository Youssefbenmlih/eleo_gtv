// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/reception_model.dart';
import 'activity_summary.dart';
import 'package:flutter/material.dart';

class RecepFloatButton extends StatelessWidget {
  List<ReceptionListElement> currentList;

  Function SendReception;
  int id;
  Object? args;

  RecepFloatButton({
    super.key,
    required this.currentList,
    required this.SendReception,
    required this.id,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (() {
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
                          is_dem: false,
                          is_rec: true,
                          res: currentList.reversed.toList()),
                      Divider(
                        color: Colors.indigo,
                        thickness: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: (() => Navigator.pop(context)),
                            child: Text(
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                                "REVENIR"),
                          ),
                          TextButton(
                            onPressed: (() async {
                              DateTime now = DateTime.now();
                              String date =
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
                              var mod = ReceptionModel(
                                  user_id: id, date: date, list: currentList);
                              String json = jsonEncode(mod);
                              int statusCode = await SendReception(json);
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
                                        Icons.warning),
                                    title: Text(
                                        style: TextStyle(color: Colors.black),
                                        "Attention"),
                                    content: Text(
                                        textAlign: TextAlign.center,
                                        """Une erreur est survenu vérifiez que votre liste de réception est correcte."""),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, "OK"),
                                          child: const Text(
                                              style: TextStyle(fontSize: 20),
                                              "OK")),
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
              content: Text(
                  textAlign: TextAlign.center,
                  """Aucune réception n'a été renseignée."""),
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
