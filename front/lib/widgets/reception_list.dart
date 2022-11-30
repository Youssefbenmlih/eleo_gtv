// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:flutter/material.dart';
import '../models/reception_model.dart';

class receptionList extends StatelessWidget {
  final List<ReceptionListElement> elements;

  final Function deleteTx;

  bool delete;

  receptionList({
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text("Aucune Réception n'est renseignée !",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ],
          )
        : SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: elements.length,
              itemBuilder: (
                context,
                index,
              ) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        width: 300,
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyan.shade700,
                              Colors.indigo,
                              Colors.cyan.shade700,
                            ],
                          ),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(
                          30,
                          10,
                          0,
                          10,
                        ),
                        child: Text(
                          "Lot ${elements.length - index} : ${elements[index].numero_de_lot}",
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
