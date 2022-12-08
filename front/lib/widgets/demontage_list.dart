// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../models/demontage_model.dart';

class DemontageList extends StatelessWidget {
  final List<DemontageListElement> elements;

  final Function deleteTx;
  bool delete;

  DemontageList({
    super.key,
    required this.elements,
    required this.deleteTx,
    this.delete = true,
  });

  @override
  Widget build(BuildContext context) {
    return elements.isEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Text("Aucun Démontage n'est renseigné !",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ],
          )
        : SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: elements.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 220,
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(colors: [
                            Colors.cyan.shade700,
                            Colors.indigo,
                            Colors.cyan.shade700
                          ]),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(30, 10, 0, 10),
                        child: Text(
                          "    Tourets  ${elements[index].touret_type} ${elements[index].cercle == "o" ? "Cerclé(s)" : "Non Cerclé(s)"} : ${elements[index].quantite_tourets}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      delete
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                deleteTx(index);
                              },
                            )
                          : Container()
                    ],
                  ),
                );
              },
            ),
          );
  }
}
