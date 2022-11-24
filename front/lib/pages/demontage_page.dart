// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:intl/intl.dart';
import '../widgets/my_app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../models/demontage_model.dart';
import '../widgets/demontage_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Demontage extends StatefulWidget {
  const Demontage({super.key});

  @override
  State<Demontage> createState() => _DemontageState();
}

class _DemontageState extends State<Demontage> {
  void wipeClean() {
    setState(() {});
  }

  void _deleteElement(int id) {
    setState(() {
      currentList.removeAt(id);
    });
  }

  List<DemontageListElement> currentList = [];

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = false;

  Future<int> SendDemontage(String demontageJson) async {
    final resp = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/activity/demontage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: demontageJson,
    );

    if (resp.statusCode == 200) {
      setState(() {
        var j = jsonDecode(resp.body);
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

    var userName = mapArgs['name'];
    var id = mapArgs['id'];

    return Scaffold(
      // floatingActionButton: DraggableFab(
      //   child: FloatingActionButton.extended(
      //     onPressed: (() {}),
      //     label: Text(
      //       style: Theme.of(context).textTheme.titleLarge,
      //       "Confirmer",
      //     ),
      //     icon: Icon(Icons.arrow_circle_right),
      //     backgroundColor: Colors.green,
      //   ),
      // ),
      appBar: MyAppBar(wipeClean, "Démontage", args),
      body: SingleChildScrollView(
        child: Column(
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
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
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
                    scale: 2.0,
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
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    style: Theme.of(context).textTheme.headlineMedium,
                    "Ingelec : ",
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Transform.scale(
                    scale: 2.0,
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
            ),
            SizedBox(
              height: 30,
            ),
            IconButton(
              highlightColor: Color.fromARGB(160, 63, 81, 181),
              onPressed: () {
                if (dropdownValue.length == 1 &&
                    numberTouretsText.text != "0") {
                  var el = DemontageListElement(
                      touret_type: dropdownValue,
                      quantite_tourets: int.parse(numberTouretsText.text),
                      cercle: isSwitchedCercle ? "o" : "n",
                      ingelec: isSwitchedIngelec ? "o" : "n");
                  setState(() {
                    currentList.add(el);
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.center,
                      icon: Icon(color: Colors.red.shade800, Icons.warning),
                      title: Text(
                          style: TextStyle(color: Colors.black), "Attention"),
                      content: Text(
                          """Veuillez emplir tous les champs avant d'ajouter l'élément."""),
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
                "Derniers Ajouts : ",
              ),
            ),
            Divider(
              color: Colors.indigo,
              thickness: 10,
            ),
            DemontageList(
              elements: currentList.reversed.toList(),
              deleteTx: _deleteElement,
            ),
            Divider(
              color: Colors.indigo,
              thickness: 10,
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              onPressed: (() {
                DateTime now = DateTime.now();
                String date = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
                var mod =
                    DemontageModel(user_id: id, date: date, list: currentList);
                String json = jsonEncode(mod);
                SendDemontage(json);
              }),
              label: Text(
                style: Theme.of(context).textTheme.titleLarge,
                "Confirmer",
              ),
              icon: Icon(Icons.arrow_circle_right),
              backgroundColor: Colors.green,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
