// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CercIngBool extends StatefulWidget {
  bool isSwitchedCercle;
  bool isSwitchedIngelec;
  bool isIng;

  Function changeC;
  Function changeI;
  CercIngBool({
    super.key,
    required this.isSwitchedCercle,
    required this.isSwitchedIngelec,
    required this.changeC,
    required this.changeI,
    this.isIng = true,
  });

  @override
  State<CercIngBool> createState() => _CercIngBoolState();
}

class _CercIngBoolState extends State<CercIngBool> {
  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Row(
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
                scale: 1.5,
                child: Switch(
                  value: widget.isSwitchedCercle,
                  onChanged: (value) {
                    setState(() {
                      widget.isSwitchedCercle = value;
                      widget.changeC();
                    });
                  },
                ),
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                style: Theme.of(context).textTheme.headlineMedium,
                "${widget.isIng ? "Ingelec" : "Démonté"} : ",
              ),
              Spacer(
                flex: 1,
              ),
              Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: widget.isSwitchedIngelec,
                  onChanged: (value) {
                    setState(() {
                      widget.isSwitchedIngelec = value;
                      widget.changeI();
                    });
                  },
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ]),
      ],
    );
  }
}
