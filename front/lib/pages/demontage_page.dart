// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class Demontage extends StatefulWidget {
  const Demontage({super.key});

  @override
  State<Demontage> createState() => _DemontageState();
}

class _DemontageState extends State<Demontage> {
  void wipeClean() {
    setState(() {});
  }

  List<String> list = <String>['Non Renseigné', 'I', 'G', 'H'];

  String dropdownValue = "Non Renseigné";

  final numberTouretsText = TextEditingController();

  bool isSwitchedCercle = false;
  bool isSwitchedIngelec = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(wipeClean, "Démontage"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                  style: Theme.of(context).textTheme.headlineMedium,
                  "Type Touret:"),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: DropdownButton<String>(
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                  style: Theme.of(context).textTheme.headlineMedium,
                  "Nombre de Tourets:"),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              alignment: Alignment.center,
              child: NumberInputPrefabbed.directionalButtons(
                controller: numberTouretsText,
                incDecBgColor: Colors.blue.shade300,
                min: 0,
                max: 2000,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                      style: Theme.of(context).textTheme.headlineMedium,
                      "Cerclé : "),
                  Spacer(
                    flex: 2,
                  ),
                  Transform.scale(
                    scale: 2.0,
                    child: Switch(
                      value: isSwitchedCercle,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedCercle = value;
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    style: Theme.of(context).textTheme.headlineMedium,
                    "Ingelec : ",
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Transform.scale(
                    scale: 2.0,
                    child: Switch(
                      value: isSwitchedIngelec,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedIngelec = value;
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: IconButton(
                padding: EdgeInsets.only(top: 30),
                onPressed: () {},
                icon: Icon(
                  color: Colors.green,
                  size: 100,
                  Icons.add_circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
