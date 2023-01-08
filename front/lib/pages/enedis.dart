// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:front/widgets/general/gradient_elevated.dart';
import 'package:front/widgets/general/my_app_bar.dart';

class Enedis extends StatefulWidget {
  const Enedis({super.key});

  @override
  State<Enedis> createState() => _EnedisState();
}

class _EnedisState extends State<Enedis> {
  void wipeClean() {
    setState(() {});
  }

  bool isValide = false;

  TextEditingController ref_touret = TextEditingController();
  TextEditingController num_controller = TextEditingController();
  TextEditingController emplacement_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: MyAppBar(wipeClean, "Emplacement Enedis", args, true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                    style: Theme.of(context).textTheme.headlineMedium,
                    "Numéro de lot:"),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 70,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (str) {
                    setState(() {
                      isValide = false;
                    });
                  },
                  autofocus: false,
                  controller: ref_touret,
                  decoration: InputDecoration(
                    hintText: "Ex : HBM1234567",
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              MyElevatedButton(
                onPressed: (() {
                  if (ref_touret.text.length == 10) {
                    setState(() {
                      isValide = true;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        alignment: Alignment.topLeft,
                        icon: Icon(Icons.warning),
                        title: Text(
                            style: TextStyle(color: Colors.black), "Attention"),
                        content: Text(
                            textAlign: TextAlign.center,
                            """Veuillez saisir un Numéro de Lot valide"""),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, "OK"),
                              child: const Text(
                                  style: TextStyle(fontSize: 20), "OK")),
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                        iconColor: Colors.red.shade800,
                      ),
                    );
                  }
                }),
                width: 180,
                height: 60,
                borderRadius: BorderRadius.circular(30),
                child: Text(
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    "Valider Lot"),
              ),
              SizedBox(height: 60),
              isValide
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      "Numéro:"),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 20,
                                  child: TextField(
                                    controller: num_controller,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      "Emplacement:"),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 20,
                                  child: TextField(
                                    controller: emplacement_controller,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        MyElevatedButton(
                          onPressed: (() {
                            if (num_controller.text.isNotEmpty &&
                                emplacement_controller.text.isNotEmpty) {
                              setState(() {
                                Navigator.pushNamed(context, "accueil",
                                    arguments: args);
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.warning),
                                  title: Text(
                                      style: TextStyle(color: Colors.black),
                                      "Attention"),
                                  content: Text(
                                      textAlign: TextAlign.center,
                                      """Veuillez remplir les infos emplacement et numéro"""),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "OK"),
                                        child: const Text(
                                            style: TextStyle(fontSize: 20),
                                            "OK")),
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                  iconColor: Colors.red.shade800,
                                ),
                              );
                            }
                          }),
                          width: 280,
                          height: 70,
                          borderRadius: BorderRadius.circular(50),
                          child: Text(
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              "Terminer"),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
