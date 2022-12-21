// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:front/globals.dart';
import 'package:front/widgets/general/cercle_ingelec.dart';
import 'package:front/widgets/demontage/demontage_fb.dart';
import 'package:front/widgets/general/detail_list.dart';
import 'package:intl/intl.dart';
import '../widgets/general/my_app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../models/demontage_model.dart';
import '../widgets/demontage/demontage_list.dart';
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
      int i = currentList.length - id - 1;
      nb_total -= currentList[i].quantite_tourets;
      currentList.removeAt(i);
    });
  }

  List<DemontageListElement> currentList = [];

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  void reset_after_add() {
    dropdownValue = list[0];
    numberTouretsText.text = "0";
    isSwitchedCercle = false;
    isSwitchedIngelec = false;
  }

  late int statusCode;
  int nb_total = 0;

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

  late String demontageJson;

  Future<int> SendDemontage(json) async {
    String url_h = getIp();
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/demontage'),
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

    return Scaffold(
      appBar: MyAppBar(wipeClean, "Démontage", args, true),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                    style: Theme.of(context).textTheme.headlineMedium,
                    "Type Touret:"),
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
                    "Nombre de Tourets:"),
              ),
              //INPUT FOR NUMBER OF TOURETS
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
              //PLUS BUTTON
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
                      nb_total += int.parse(numberTouretsText.text);
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
                  "Nombre total de tourets : $nb_total",
                ),
              ),
              Divider(
                color: Colors.indigo,
                thickness: 10,
              ),
              //LIST OF ADDED ELEMENTS
              DemontageList(
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
              DemoFloatButton(
                currentList: currentList,
                SendDemontage: SendDemontage,
                id: id,
                args: args,
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
