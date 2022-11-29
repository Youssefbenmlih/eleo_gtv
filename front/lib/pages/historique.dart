// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:front/widgets/historique_list.dart';
import 'package:front/widgets/my_app_bar.dart';

class Historique extends StatelessWidget {
  const Historique({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;
    var id = mapArgs['id'];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
          ),
          child: Icon(size: 45, Icons.refresh),
        ),
      ),
      appBar: MyAppBar(() {}, "HISTORIQUE", args, false),
      body: HistoriqueList(
        elements: [2, 3, 4, 5],
        name: 'Youssef',
      ),
    );
  }
}
