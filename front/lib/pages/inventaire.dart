// // ignore_for_file: prefer_const_constructors, non_constant_identifier_names

// import 'package:flutter/material.dart';
// import '../widgets/my_app_bar.dart';

// class Inventaire extends StatefulWidget {
//   const Inventaire({super.key});

//   @override
//   State<Inventaire> createState() => _InventaireState();
// }

// class _InventaireState extends State<Inventaire> {
//   void wipeClean() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments;
//     final mapArgs = args as Map;

//     var userName = mapArgs['name'];
//     var id = mapArgs['id'];
//     return Scaffold(
//       appBar: MyAppBar(wipeClean, "Inventaire", args),
//     );
//   }
// }