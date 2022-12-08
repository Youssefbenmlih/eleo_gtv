// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:front/widgets/general/cercle_ingelec.dart';
import 'package:front/widgets/reception/reception_fb.dart';
import '../globals.dart';
import '../widgets/general/my_app_bar.dart';
import '../models/reception_model.dart';
import '../widgets/reception/reception_list.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
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

  List<String> l = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = true;

  Future<int> SendReception(json) async {
    String url_h = getIp();
    final resp = await http.post(
      Uri.parse('$url_h/api/activity/reception'),
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
            //SWITCHES
            CercIngBool(
              isSwitchedCercle: isSwitchedCercle,
              isSwitchedIngelec: isSwitchedIngelec,
              changeC: changeSwitchCercle,
              changeI: changeSwitchIngelec,
            ),
            //LOT NUMBER INPUT OR NORMAL TOURETS INPUT
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
            //PLUS BUTTON TO ADD TO LIST
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
            //LIST OF ADDED ELEMENTS
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
            //CONFIRM BUTTON
            RecepFloatButton(
              currentList: currentList,
              SendReception: SendReception,
              id: id,
              args: args,
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
