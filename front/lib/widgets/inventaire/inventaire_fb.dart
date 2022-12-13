// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front/models/inventaire_model.dart';
import '../general/gradient_elevated.dart';

class InventFloatButton extends StatefulWidget {
  Function SendInventaire;
  bool isSwitchedCercle;
  bool isSwitchedDemonte;
  int id;
  Object? args;
  Map data;
  TextEditingController numberTouretsText;
  String dropdownValue;
  int current_stock_value;

  InventFloatButton({
    super.key,
    required this.numberTouretsText,
    required this.dropdownValue,
    required this.data,
    required this.SendInventaire,
    required this.id,
    required this.args,
    required this.isSwitchedCercle,
    required this.isSwitchedDemonte,
    required this.current_stock_value,
  });

  @override
  State<InventFloatButton> createState() => _InventFloatButtonState();
}

class _InventFloatButtonState extends State<InventFloatButton> {
  @override
  Widget build(BuildContext context) {
    return MyElevatedButton(
      onPressed: (() {
        setState(
          () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                alignment: Alignment.center,
                icon: Icon(Icons.warning),
                title: Text(
                    style: TextStyle(color: Colors.black),
                    "Envoi d'inventaire"),
                content: Text(
                    textAlign: TextAlign.center,
                    """Êtes-vous sûr de vos modifications ?"""),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, "ANNULER"),
                    child:
                        const Text(style: TextStyle(fontSize: 20), "ANNULER"),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.green.shade400, // Text Color
                    ),
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String date =
                          DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
                      var inventaire = InventaireModel(
                        user_id: widget.id,
                        date: date,
                        type_touret: widget.dropdownValue,
                        nb_monte_cercle:
                            widget.isSwitchedCercle && !widget.isSwitchedDemonte
                                ? (int.parse(widget.numberTouretsText.text) -
                                        widget.data[widget.dropdownValue]
                                            ["stock_monte_cercle"])
                                    .toInt()
                                : 0,
                        nb_demonte_cercle:
                            widget.isSwitchedCercle && widget.isSwitchedDemonte
                                ? (int.parse(widget.numberTouretsText.text) -
                                        widget.data[widget.dropdownValue]
                                            ["stock_demonte_cercle"])
                                    .toInt()
                                : 0,
                        nb_monte_non_cercle: !widget.isSwitchedCercle &&
                                !widget.isSwitchedDemonte
                            ? (int.parse(widget.numberTouretsText.text) -
                                    widget.data[widget.dropdownValue]
                                        ["stock_monte_non_cercle"])
                                .toInt()
                            : 0,
                        nb_demonte_non_cercle:
                            !widget.isSwitchedCercle && widget.isSwitchedDemonte
                                ? (int.parse(widget.numberTouretsText.text) -
                                        widget.data[widget.dropdownValue]
                                            ["stock_demonte_non_cercle"])
                                    .toInt()
                                : 0,
                        stock_avant: widget.current_stock_value,
                        stock_apres: int.parse(widget.numberTouretsText.text),
                      );
                      String json = jsonEncode(inventaire);
                      int statusCode = await widget.SendInventaire(json);
                      if (statusCode == 200) {
                        Navigator.pushNamed(context, "accueil",
                            arguments: widget.args);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            alignment: Alignment.center,
                            icon: Icon(
                              color: Colors.red.shade800,
                              Icons.warning,
                            ),
                            title: Text(
                              style: TextStyle(color: Colors.black),
                              "Attention",
                            ),
                            content: Text(
                                textAlign: TextAlign.center,
                                """Une erreur est survenu"""),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                    style: TextStyle(fontSize: 20), "OK"),
                              ),
                            ],
                            actionsAlignment: MainAxisAlignment.center,
                            iconColor: Colors.blue,
                          ),
                        );
                      }
                    },
                    child: Text(
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        "OUI"),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.spaceBetween,
                iconColor: Colors.red.shade800,
              ),
            );
          },
        );
      }),
      height: 70,
      borderRadius: BorderRadius.circular(30),
      width: 300,
      gradient: LinearGradient(colors: [
        Color.fromARGB(255, 97, 191, 102),
        Colors.green,
        Color.fromARGB(255, 97, 191, 102),
      ]),
      child: Text(
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        "Confirmer",
      ),
    );
  }
}
