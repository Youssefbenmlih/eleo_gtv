// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:front/globals.dart';
import 'package:front/widgets/general/cercle_ingelec.dart';
import 'package:front/widgets/chargement/chargement_fb.dart';
import '../widgets/general/my_app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../models/chargement_model.dart';
import '../widgets/chargement/chargement_list.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Chargement extends StatefulWidget {
  const Chargement({super.key});

  @override
  State<Chargement> createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  void wipeClean() {
    setState(() {});
  }

  void _deleteElement(int id) {
    setState(() {
      var i = currentList.length - id - 1;
      var t = (currentList[i].quantite_joues / 2) *
          type_poids[currentList[i].touret_type]!;
      setState(() {
        tare -= t.toInt();
      });
      currentList.removeAt(i);
    });
  }

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = false;

  void changeSwitchCercle() {
    setState(() {
      isSwitchedCercle = !isSwitchedCercle;
    });
  }

  void changeSwitchIngelec() {
    setState(() {
      isSwitchedIngelec = !isSwitchedIngelec;
    });
  }

  void reset_after_add() {
    dropdownValue = list[0];
    numberTouretsText.text = "0";
    isSwitchedCercle = false;
    isSwitchedIngelec = false;
  }

  List<ChargementListElement> currentList = [];
  //REMOVE HARDCODING
  var type_poids = {'G': 220, 'H': 320, 'I': 420};

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  late int statusCode;

  int tare = 0;

  Future<int> sendChargement(json) async {
    String url_h = getIp();
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/chargement'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json,
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
    var id = mapArgs['id'];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: MyAppBar(wipeClean, "Chargement", args, true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                    style: Theme.of(context).textTheme.headlineMedium,
                    "Type Joues:"),
              ),
              //DROPDOWN MENU FOR TYPE
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
                    "Nombre de Joues:"),
              ),
              //INPUT FOR NB OF JOUES
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
              SizedBox(
                height: 20,
              ),
              //SWITCHES
              CercIngBool(
                isSwitchedCercle: isSwitchedCercle,
                isSwitchedIngelec: isSwitchedIngelec,
                changeC: changeSwitchCercle,
                changeI: changeSwitchIngelec,
              ),
              SizedBox(
                height: 20,
              ),
              //ADD ELEMENT TO LIST BUTTON
              IconButton(
                highlightColor: Color.fromARGB(160, 63, 81, 181),
                onPressed: () {
                  if (dropdownValue.length == 1 &&
                      numberTouretsText.text != "0" &&
                      int.parse(numberTouretsText.text) % 2 == 0) {
                    var t = (double.parse(numberTouretsText.text) / 2) *
                        type_poids[dropdownValue]!;
                    setState(() {
                      tare += t.toInt();
                    });
                    var el = ChargementListElement(
                      touret_type: dropdownValue,
                      quantite_joues: int.parse(numberTouretsText.text),
                      cercle: isSwitchedCercle ? "o" : "n",
                      ingelec: isSwitchedIngelec ? "o" : "n",
                      Tare: 0,
                    );
                    setState(() {
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
                            style: TextStyle(color: Colors.black), "Attention"),
                        content: Text(
                            textAlign: TextAlign.center,
                            """Veuillez bien remplir tous les champs avant d'ajouter l'élément. (Vérifiez que le nombre de joues entré est pair)"""),
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
                  "Tare totale: $tare",
                ),
              ),
              Divider(
                color: Colors.indigo,
                thickness: 10,
              ),
              //LIST OF ADDED ELEMENTS
              chargementList(
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
              //CONFIRM BUTTON
              ChargFloatButton(
                currentList: currentList,
                sendChargement: sendChargement,
                id: id,
                args: args,
                tare: tare,
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
