// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:intl/intl.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../models/reception_model.dart';
import '../widgets/reception_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      currentList.removeAt(currentList.length - id - 1);
    });
  }

  List<ReceptionListElement> currentList = [];
  List<String> list = <String>['I', 'G', 'H'];
  final numeroLotText = TextEditingController();

  late int statusCode;

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = false;

  late String receptionJson;

  Future<int> SendReception() async {
    final resp = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/activity/reception'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: receptionJson,
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
      appBar: MyAppBar(wipeClean, "Réception", args),
      body: SingleChildScrollView(
        child: Column(
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
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                child: TextField(
                  controller: numeroLotText,
                )),
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
                if (numeroLotText.text.length == 10 &&
                    list.contains(numeroLotText.text[0])) {
                  var el = ReceptionListElement(
                      touret_type: numeroLotText.text[0],
                      numero_de_lot: numeroLotText.text,
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
                      content:
                          Text("""Le numéro de lot saisi est incorrect."""),
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
              onPressed: (() async {
                if (currentList.isNotEmpty) {
                  DateTime now = DateTime.now();
                  String date = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
                  var mod = ReceptionModel(
                      user_id: id, date: date, list: currentList);
                  String json = jsonEncode(mod);
                  receptionJson = json;
                  int statusCode = await SendReception();
                  if (statusCode == 200) {
                    Navigator.pushNamed(context, "accueil", arguments: args);
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
                            """Une erreur est survenu vérifiez que votre liste de réception est correcte."""),
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
