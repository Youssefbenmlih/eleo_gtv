// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:front/widgets/general/cercle_ingelec.dart';
import 'package:front/widgets/general/gradient_elevated.dart';
import 'package:front/widgets/inventaire/inventaire_fb.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../globals.dart';
import '../widgets/general/my_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Inventaire extends StatefulWidget {
  const Inventaire({super.key});

  @override
  State<Inventaire> createState() => _InventaireState();
}

class _InventaireState extends State<Inventaire> {
  void wipeClean() {
    setState(() {});
  }

  String url_h = getIp();

  Future<int> SendInventaire(content) async {
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/inventaire'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: content,
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

  Future<Map> fetchStock() async {
    final response = await http.get(Uri.parse('$url_h/api/stock/get'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then return
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get stock');
    }
  }

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  bool isSwitchedCercle = false;
  bool isSwitchedDemonte = false;
  bool isValide = false;

  int current_stock_value = 0;

  TextEditingController numberTouretsText = TextEditingController();

  Map data = {
    'G': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'H': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'I': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
  };

  bool b = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    var id = mapArgs['id'];

    while (!b) {
      fetchStock().then((value) {
        setState(
          () {
            data = value;
          },
        );
      });
      b = true;
    }

    String currentSelectedTouret =
        "Touret $dropdownValue ${isSwitchedDemonte ? "Démonté" : "Monté"} ${isSwitchedCercle ? "Cerclé" : "Non Cerclé"} : (Stock actuel : $current_stock_value)";
    current_stock_value = data[dropdownValue.length != 1 ? 'G' : dropdownValue][
        "stock_${isSwitchedDemonte ? "de" : ""}monte_${isSwitchedCercle ? "" : "non_"}cercle"];

    return Scaffold(
      appBar: MyAppBar(wipeClean, "Inventaire", args, true),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
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
                      isValide = false;
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
              SizedBox(
                height: 30,
              ),
              CercIngBool(
                isIng: false,
                isSwitchedCercle: isSwitchedCercle,
                isSwitchedIngelec: isSwitchedDemonte,
                changeC: () {
                  setState(() {
                    isSwitchedCercle = !isSwitchedCercle;
                  });
                },
                changeI: () {
                  setState(() {
                    isSwitchedDemonte = !isSwitchedDemonte;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              MyElevatedButton(
                onPressed: (() {
                  if (dropdownValue.length == 1) {
                    setState(() {
                      isValide = true;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        alignment: Alignment.topLeft,
                        icon: Icon(Icons.warning),
                        title: Text(
                            style: TextStyle(color: Colors.black), "Attention"),
                        content: Text(
                            textAlign: TextAlign.center,
                            """Veuillez saisir un type de touret"""),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, "OK"),
                              child: const Text(
                                  style: TextStyle(fontSize: 20), "OK")),
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                        iconColor: Colors.red.shade800,
                      ),
                    );
                  }
                }),
                width: 200,
                borderRadius: BorderRadius.circular(30),
                child: Text(
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    "Valider"),
              ),
              isValide
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            style: Theme.of(context).textTheme.labelLarge,
                            currentSelectedTouret,
                          ),
                        ),
                        SizedBox(height: 50),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Text(
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headlineLarge,
                              "Entrez la nouvelle valeur de stock : ",
                            ),
                          ),
                        ),
                        Container(
                          width: 350,
                          height: 70,
                          margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                            initialValue: current_stock_value,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InventFloatButton(
                          numberTouretsText: numberTouretsText,
                          dropdownValue: dropdownValue,
                          data: data,
                          SendInventaire: SendInventaire,
                          id: id,
                          args: args,
                          isSwitchedCercle: isSwitchedCercle,
                          isSwitchedDemonte: isSwitchedDemonte,
                          current_stock_value: current_stock_value,
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
