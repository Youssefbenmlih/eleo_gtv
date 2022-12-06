// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:front/models/chargement_model.dart';
import 'package:front/models/reception_model.dart';
import 'package:front/widgets/demontage_list.dart';
import 'package:front/widgets/detail_list.dart';
import '../globals.dart';
import '../models/Historique_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import '../models/demontage_model.dart';

class HistoriqueList extends StatefulWidget {
  final List<HistoriqueModel> elements;

  HistoriqueList({
    super.key,
    required this.elements,
  });

  @override
  State<HistoriqueList> createState() => _HistoriqueListState();
}

class _HistoriqueListState extends State<HistoriqueList> {
  var formatter = DateFormat('dd/MM/yyyy hh:mm:ss');

  Future<List> fetchActivityDetail(activity, id) async {
    String url_h = getIp();
    final response = await http.post(
      Uri.parse('$url_h/api/historique/det_$activity'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then return
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get historique');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.elements.isEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Center(
                  child: Text(
                    "Aucune activité.",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: widget.elements.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Date : ${formatter.format(widget.elements[index].date)}",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              widget.elements[index].activity_name,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Nom d'utilisateur: ${widget.elements[index].user_name}"),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              iconSize: 40,
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              onPressed: (() async {
                                bool dem = false;
                                bool rec = false;
                                String acid =
                                    widget.elements[index].activity_id;
                                List res = [];
                                List detail_list = await fetchActivityDetail(
                                    acid, widget.elements[index].id);
                                if (acid == "dem") {
                                  dem = true;
                                  res = detail_list
                                      .map(
                                        (el) => DemontageListElement(
                                            touret_type: el['touret_type'],
                                            quantite_tourets:
                                                el['quantite_tourets'],
                                            cercle: el['cercle'],
                                            ingelec: el['ingelec']),
                                      )
                                      .toList();
                                } else if (acid == "rec") {
                                  rec = true;
                                  res = detail_list
                                      .map(
                                        (el) => ReceptionListElement(
                                          touret_type: el['touret_type'],
                                          numero_de_lot: el['numero_de_lot'],
                                          cercle: el['cercle'],
                                          ingelec: el['ingelec'],
                                          quantite_tourets:
                                              el['quantite_tourets'],
                                        ),
                                      )
                                      .toList();
                                } else {
                                  res = detail_list
                                      .map(
                                        (el) => ChargementListElement(
                                          touret_type: el['touret_type'],
                                          quantite_joues: el['quantite_joues'],
                                          cercle: el['cercle'],
                                          ingelec: el['ingelec'],
                                          Tare: 0,
                                        ),
                                      )
                                      .toList();
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          width: 400,
                                          height: 400,
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  "Détails :"),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Divider(
                                                color: Colors.indigo,
                                                thickness: 10,
                                              ),
                                              DetailList(
                                                  is_dem: dem,
                                                  is_rec: rec,
                                                  res: res),
                                              Divider(
                                                color: Colors.indigo,
                                                thickness: 10,
                                              ),
                                              TextButton(
                                                onPressed: (() {
                                                  Navigator.pop(context);
                                                }),
                                                child: Text(
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    "OK"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                              icon: Icon(Icons.menu),
                            ),
                            Text("Détails"),
                            SizedBox(height: 5),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
