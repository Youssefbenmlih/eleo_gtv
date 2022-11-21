// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function deleteTx;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTx,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Text("No Transactions have been registered yet !",
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: SizedBox(
                    height: 380,
                    child: Image.asset(
                      "assets/images/rich_guy.png",
                      fit: BoxFit.cover,
                    )),
              ),
            ],
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Text(
                        "${transactions[index].amount.toStringAsFixed(2)}€",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transactions[index].title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(transactions[index].date),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          deleteTx(transactions[index].id);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
