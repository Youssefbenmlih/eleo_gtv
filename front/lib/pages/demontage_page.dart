// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';

class Demontage extends StatefulWidget {
  const Demontage({super.key});

  @override
  State<Demontage> createState() => _DemontageState();
}

class _DemontageState extends State<Demontage> {
  void wipeClean() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(wipeClean, "Démontage"),
    );
  }
}
