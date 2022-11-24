// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';

class Chargement extends StatefulWidget {
  const Chargement({super.key});

  @override
  State<Chargement> createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  void wipeClean() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    var userName = mapArgs['name'];
    var id = mapArgs['id'];

    return Scaffold(
      appBar: MyAppBar(wipeClean, "Chargement", args),
    );
  }
}
