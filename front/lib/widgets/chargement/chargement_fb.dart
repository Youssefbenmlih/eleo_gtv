// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously, prefer_const_declarations, unused_local_variable
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../models/chargement_model.dart';
import '../general/activity_summary.dart';
import 'package:flutter/material.dart';

class ChargFloatButton extends StatelessWidget {
  List<ChargementListElement> currentList;
  Function sendChargement;
  int id;
  Object? args;
  int tare;
  ChargFloatButton({
    super.key,
    required this.currentList,
    required this.sendChargement,
    required this.id,
    required this.args,
    required this.tare,
  });

  Future sendEmail({
    required String tare,
    required String resume_joues,
    required String date,
  }) async {
    final serviceId = 'service_yao7rvc';
    final templateId = 'template_iqfyzoe';
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
            'date': date,
            'resume_joues': resume_joues,
            'tare': tare,
          }
        }));
  }

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
                          is_dem: false,
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
                              var now = DateTime.now();
                              String date =
                                  DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
                              var mod = ChargementModel(
                                user_id: id,
                                date: date,
                                list: currentList,
                                tare_total: tare,
                              );
                              String json = jsonEncode(mod);
                              int statusCode = await sendChargement(json);
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
                                        """Une erreur est survenu vérifiez que votre liste de démontage est correcte."""),
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
                              // - SEND EMAIL TO GAETAN
                              var mail = await sendEmail(
                                tare: tare.toString(),
                                resume_joues: currentList
                                    .map((e) =>
                                        """\n${e.quantite_joues} joues de type ${e.touret_type.toUpperCase()} ${e.cercle == 'o' ? 'Cercle' : 'Non cerclé'}\n""")
                                    .toString(),
                                date: date.toString(),
                              );
                              //
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
