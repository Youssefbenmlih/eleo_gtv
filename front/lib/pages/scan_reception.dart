// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';

class Reception extends StatefulWidget {
  const Reception({super.key});

  @override
  State<Reception> createState() => _ReceptionState();
}

class _ReceptionState extends State<Reception> {
  void wipeClean() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(wipeClean, "Réception"),
    );
  }
}
