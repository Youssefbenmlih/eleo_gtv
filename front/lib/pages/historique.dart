// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:front/models/Historique_model.dart';
import 'package:front/widgets/general/gradient_elevated.dart';
import 'package:front/widgets/historique/historique_list.dart';
import 'package:front/widgets/general/my_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../globals.dart';

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  bool b = false;
  String url_h = getIp();

  Future<Map> fetchHistorique() async {
    final response = await http.get(Uri.parse('$url_h/api/historique/list'));

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

  Future<List> fetchUsername() async {
    final response = await http.get(Uri.parse('$url_h/api/users/list'));

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

  void fetchall() {
    fetchUsername().then((value) {
      setState(
        () {
          for (var el in value) {
            user_names[el['id']] = el['name'];
          }
        },
      );
    });
    fetchHistorique().then((value) {
      setState(
        () {
          data = value;
          create_all_list(data);
        },
      );
    });
    b = true;
  }

  List map_activity_list(data, type, tare, name, id) {
    return data[type].map((element) {
      String sDate = element['date'];
      final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
      final dateTime = formatter.parse(sDate);
      return HistoriqueModel(
        id: element['id'],
        activity_id: id,
        user_name: user_names[element['id_user']],
        date: dateTime,
        list: [],
        activity_name: name,
        tare: tare ? element['tare_total'] : null,
      );
    }).toList();
  }

  void create_all_list(data) {
    List d = map_activity_list(
        data, 'demontage', false, 'Démontage de Tourets', "dem");
    List r = map_activity_list(
        data, 'reception', false, 'Réception Tourets Vides', "rec");
    List c = map_activity_list(
        data, 'chargement', true, 'Chargement Tourets Vides', "cha");
    dem = d;
    rec = r;
    cha = c;
    all_list = [...d, ...r, ...c];
    all_list.sort((a, b) {
      return b.date.compareTo(a.date);
    });
  }

  List<HistoriqueModel> getList() {
    List<HistoriqueModel> list = [
      if (display_dem) ...dem,
      if (display_rec) ...rec,
      if (display_cha) ...cha
    ];
    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    return list;
  }

  Map data = {};
  List<HistoriqueModel> all_list = [];
  bool display_dem = true;
  bool display_rec = true;
  bool display_cha = true;
  List dem = [];
  List rec = [];
  List cha = [];
  Map user_names = {};
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;
    var id = mapArgs['id'];

    if (!b) {
      fetchall();
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          fetchall();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
          ),
          child: Icon(size: 35, Icons.refresh),
        ),
      ),
      appBar: MyAppBar(() {}, "HISTORIQUE", args, false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyElevatedButton(
                  borderRadius: BorderRadius.circular(30),
                  gradient: display_dem
                      ? const LinearGradient(
                          colors: [Colors.cyan, Colors.indigo],
                        )
                      : LinearGradient(colors: [
                          Colors.cyan.shade100,
                          Colors.indigo.shade100
                        ]),
                  width: 100,
                  onPressed: () {
                    setState(() {
                      display_dem = !display_dem;
                    });
                  },
                  child: Text(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      "Démont."),
                ),
                MyElevatedButton(
                  borderRadius: BorderRadius.circular(30),
                  gradient: display_rec
                      ? const LinearGradient(
                          colors: [Colors.cyan, Colors.indigo],
                        )
                      : LinearGradient(colors: [
                          Colors.cyan.shade100,
                          Colors.indigo.shade100
                        ]),
                  onPressed: () {
                    setState(() {
                      display_rec = !display_rec;
                    });
                  },
                  width: 100,
                  child: Text(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      "Récep."),
                ),
                MyElevatedButton(
                  borderRadius: BorderRadius.circular(30),
                  gradient: display_cha
                      ? const LinearGradient(
                          colors: [Colors.cyan, Colors.indigo],
                        )
                      : LinearGradient(colors: [
                          Colors.cyan.shade100,
                          Colors.indigo.shade100
                        ]),
                  onPressed: () {
                    setState(() {
                      display_cha = !display_cha;
                    });
                  },
                  width: 100,
                  child: Text(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      "Charg."),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 4,
            ),
            HistoriqueList(
              elements: getList(),
            ),
          ],
        ),
      ),
    );
  }
}
