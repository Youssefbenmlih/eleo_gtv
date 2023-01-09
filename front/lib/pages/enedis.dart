// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/general/gradient_elevated.dart';
import 'package:front/widgets/general/my_app_bar.dart';

import '../globals.dart';

class Enedis extends StatefulWidget {
  const Enedis({super.key});

  @override
  State<Enedis> createState() => _EnedisState();
}

class _EnedisState extends State<Enedis> {
  void wipeClean() {
    setState(() {});
  }

  String url_h = getIp();

  bool isValide = false;
  late Map enedis_stock;
  List<String> suggestions = [];
  TextEditingController ref_touret = TextEditingController();
  TextEditingController num_controller = TextEditingController();
  TextEditingController emplacement_controller = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  Future<Map> fetchStock() async {
    final response = await http.get(Uri.parse('$url_h/api/enedis/list'));

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

  Future<int> SendEnedisPlacement() async {
    final resp = await http.post(
      Uri.parse(
          '$url_h/api/enedis/edit/${ref_touret.text}/${num_controller.text}/${emplacement_controller.text}'),
    );

    if (resp.statusCode == 200) {
      setState(() {});
    } else {
      setState(() {});
    }
    return resp.statusCode;
  }

  void get_stock_enedis() async {
    await fetchStock().then((value) {
      setState(() {
        enedis_stock = value;
        enedis_stock.forEach((key, value) => suggestions.add(key));
      });
    });
  }

  @override
  initState() {
    super.initState();
    get_stock_enedis();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: MyAppBar(wipeClean, "Emplacement Enedis", args, true),
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
              SizedBox(
                height: 20,
              ),
              Container(
                width: 240,
                height: 70,
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                alignment: Alignment.center,
                child: SimpleAutoCompleteTextField(
                  key: key,
                  suggestions: suggestions,
                  textChanged: (str) {
                    setState(() {
                      isValide = false;
                    });
                  },
                  autofocus: false,
                  controller: ref_touret,
                  decoration: InputDecoration(
                    hintText: "Ex : HBM1234567",
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              MyElevatedButton(
                onPressed: (() {
                  if (ref_touret.text.length == 10) {
                    setState(() {
                      isValide = true;
                      num_controller.text =
                          suggestions.contains(ref_touret.text)
                              ? enedis_stock[ref_touret.text]['numero']
                              : "";
                      emplacement_controller.text =
                          suggestions.contains(ref_touret.text)
                              ? enedis_stock[ref_touret.text]['place']
                              : "";
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
                            """Veuillez saisir un Numéro de Lot valide"""),
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
                width: 180,
                height: 60,
                borderRadius: BorderRadius.circular(30),
                child: Text(
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    "Valider Lot"),
              ),
              SizedBox(height: 60),
              isValide
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      "Numéro Ligne:"),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 20,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Ex : B-A",
                                    ),
                                    controller: num_controller,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      "Emplacement:"),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 20,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Ex : 12",
                                    ),
                                    controller: emplacement_controller,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        MyElevatedButton(
                          onPressed: (() async {
                            if (num_controller.text.isNotEmpty &&
                                emplacement_controller.text.isNotEmpty) {
                              int resp = await SendEnedisPlacement();
                              if (resp == 200) {
                                setState(() {
                                  Navigator.pushNamed(context, "accueil",
                                      arguments: args);
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    alignment: Alignment.topLeft,
                                    icon: Icon(Icons.warning),
                                    title: Text(
                                        style: TextStyle(color: Colors.black),
                                        "Erreur"),
                                    content: Text(
                                        textAlign: TextAlign.center,
                                        """Erreur lors de l'envoi d'informations"""),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, "OK"),
                                          child: const Text(
                                              style: TextStyle(fontSize: 20),
                                              "OK")),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                    iconColor: Colors.red.shade800,
                                  ),
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.warning),
                                  title: Text(
                                      style: TextStyle(color: Colors.black),
                                      "Attention"),
                                  content: Text(
                                      textAlign: TextAlign.center,
                                      """Veuillez remplir les infos emplacement et numéro"""),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "OK"),
                                        child: const Text(
                                            style: TextStyle(fontSize: 20),
                                            "OK")),
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                  iconColor: Colors.red.shade800,
                                ),
                              );
                            }
                          }),
                          width: 280,
                          height: 70,
                          borderRadius: BorderRadius.circular(50),
                          child: Text(
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              "Terminer"),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
