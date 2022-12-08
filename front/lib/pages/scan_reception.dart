// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:front/widgets/activity_summary.dart';
import 'package:front/widgets/detail_list.dart';
import '../globals.dart';
import '../widgets/my_app_bar.dart';
import 'package:intl/intl.dart';
import '../models/reception_model.dart';
import '../widgets/reception_list.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class Reception extends StatefulWidget {
  const Reception({super.key});

  @override
  State<Reception> createState() => _ReceptionState();
}

class _ReceptionState extends State<Reception> {
  void wipeClean() {
    setState(() {});
  }

  void _deleteElement(int id) {
    setState(() {
      nb_lot -= 1;
      currentList.removeAt(currentList.length - id - 1);
    });
  }

  void reset_after_add() {
    numberTouretsText.text = "0";
    dropdownValue = "Non Renseigné";
    numeroLotText.text = "";
    isSwitchedCercle = false;
  }

  List<ReceptionListElement> currentList = [];
  List<String> list = <String>['I', 'G', 'H'];
  final numeroLotText = TextEditingController();

  late int statusCode;
  int nb_lot = 0;

  List<String> l = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = true;

  late String receptionJson;

  Future<int> SendReception() async {
    String url_h = getIp();
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/reception'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: receptionJson,
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    // ignore: unused_local_variable
    var userName = mapArgs['name'];
    var id = mapArgs['id'];
    return Scaffold(
      appBar: MyAppBar(wipeClean, "Réception", args, true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
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
                        "Ingelec : ",
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: isSwitchedIngelec,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedIngelec = value;
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
            isSwitchedIngelec
                ? (Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            "Numéro de lot:"),
                      ),
                      Container(
                        width: 350,
                        height: 70,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: numeroLotText,
                        ),
                      )
                    ],
                  ))
                : (Column(
                    children: [
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
                            });
                          },
                          items: l.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            "Nombre de Tourets:"),
                      ),
                      Container(
                        width: 350,
                        height: 70,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                        ),
                      ),
                    ],
                  )),
            SizedBox(
              height: 10,
            ),
            IconButton(
              highlightColor: Color.fromARGB(160, 63, 81, 181),
              onPressed: () {
                int qt = 1;
                if ((isSwitchedIngelec &&
                        numeroLotText.text.length == 10 &&
                        list.contains(numeroLotText.text[0].toUpperCase())) ||
                    (!isSwitchedIngelec &&
                        dropdownValue != "Non Renseigné" &&
                        numberTouretsText.text != "0")) {
                  late ReceptionListElement el;
                  if (isSwitchedIngelec) {
                    el = ReceptionListElement(
                      touret_type: numeroLotText.text[0].toUpperCase(),
                      numero_de_lot: numeroLotText.text.toUpperCase(),
                      cercle: isSwitchedCercle ? "o" : "n",
                      ingelec: isSwitchedIngelec ? "o" : "n",
                      quantite_tourets: 1,
                    );
                  } else {
                    el = ReceptionListElement(
                      touret_type: dropdownValue,
                      numero_de_lot: "",
                      cercle: isSwitchedCercle ? "o" : "n",
                      ingelec: isSwitchedIngelec ? "o" : "n",
                      quantite_tourets: int.parse(numberTouretsText.text),
                    );
                    qt = int.parse(numberTouretsText.text);
                  }

                  setState(() {
                    setState(() {
                      nb_lot += qt;
                    });
                    currentList.add(el);
                    reset_after_add();
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.center,
                      icon: Icon(color: Colors.red.shade800, Icons.warning),
                      title: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          "Attention"),
                      content: Text(
                          textAlign: TextAlign.center,
                          isSwitchedIngelec
                              ? "Le numéro de lot saisi est incorrect."
                              : "Veuillez remplir toutes les informations"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, "OK"),
                            child: const Text(
                                style: TextStyle(fontSize: 20), "OK")),
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                      iconColor: Colors.blue,
                    ),
                  );
                }
              },
              iconSize: 80.0,
              icon: Icon(
                color: Colors.blueAccent,
                Icons.add_box,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text(
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
                "Nombre de lots : $nb_lot",
              ),
            ),
            Divider(
              color: Colors.indigo,
              thickness: 10,
            ),
            receptionList(
              elements: currentList.reversed.toList(),
              deleteTx: _deleteElement,
            ),
            Divider(
              color: Colors.indigo,
              thickness: 10,
            ),
            SizedBox(
              height: 40,
            ),
            FloatingActionButton.extended(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                          DateFormat('dd/MM/yyyy HH:mm:ss')
                                              .format(now);
                                      var mod = ReceptionModel(
                                          user_id: id,
                                          date: date,
                                          list: currentList);
                                      String json = jsonEncode(mod);
                                      receptionJson = json;
                                      int statusCode = await SendReception();
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                                "Attention"),
                                            content: Text(
                                                textAlign: TextAlign.center,
                                                """Une erreur est survenu vérifiez que votre liste de réception est correcte."""),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, "OK"),
                                                  child: const Text(
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                      "OK")),
                                            ],
                                            actionsAlignment:
                                                MainAxisAlignment.center,
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
                      title: Text(
                          style: TextStyle(color: Colors.black), "Attention"),
                      content: Text(
                          textAlign: TextAlign.center,
                          """Aucune réception n'a été renseignée."""),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, "OK"),
                            child: const Text(
                                style: TextStyle(fontSize: 20), "OK")),
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
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
