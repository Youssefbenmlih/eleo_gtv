// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransHandler;

  NewTransaction(this.addTransHandler);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TitleController = TextEditingController();

  final AmountController = TextEditingController();

  DateTime? datePicked;

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2055),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          datePicked = value;
        });
      }
    });
  }

  void _submitData() {
    widget.addTransHandler(
      TitleController.text,
      double.parse(AmountController.text),
      datePicked ?? DateTime.now(),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: TitleController,
              onSubmitted: (_) => _submitData(),
              decoration: InputDecoration(
                label: Text("Title"),
              ),
            ),
            TextField(
              controller: AmountController,
              onSubmitted: (_) => _submitData(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text("Amount"),
              ),
            ),
            Row(
              children: [
                Text("Select Date: "),
                TextButton(
                  onPressed: presentDatePicker,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    datePicked == null
                        ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                        : DateFormat('dd/MM/yyyy')
                            .format(datePicked as DateTime),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _submitData,
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
