// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import '../models/Historique_model.dart';

class HistoriqueList extends StatelessWidget {
  //NEEED TOOO CHAAANGE THIS
  final List<int> elements;

  String name = "who?";

  HistoriqueList({
    super.key,
    required this.name,
    required this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return elements.isEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Aucune activité.",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: double.infinity,
              child: ListView.builder(
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Date : 2/12/2022",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              style: Theme.of(context).textTheme.headlineMedium,
                              "Réception de tourets vides",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Nom d'utilisateur: $name"),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              iconSize: 40,
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              onPressed: (() {}),
                              icon: Icon(Icons.menu),
                            ),
                            Text("Détails"),
                            SizedBox(height: 5),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
