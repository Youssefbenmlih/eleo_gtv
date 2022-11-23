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
    return Scaffold(
      appBar: MyAppBar(wipeClean, "Chargement"),
    );
  }
}
