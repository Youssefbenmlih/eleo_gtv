// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:front/widgets/my_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import '../globals.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  Future<Map> fetchStock() async {
    String url_h = getIp();
    final response = await http.get(Uri.parse('$url_h/api/stock/get'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then return
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get stock');
    }
  }

  late Map data = {
    'G': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'H': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
    'I': {
      'stock_monte_cercle': 0,
      'stock_demonte_cercle': 0,
      'stock_monte_non_cercle': 0,
      'stock_demonte_non_cercle': 0
    },
  };

  bool b = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;
    var id = mapArgs['id'];

    if (!b) {
      fetchStock().then((value) {
        setState(
          () {
            data = value;
          },
        );
      });
      b = true;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchStock().then((value) {
            setState(
              () {
                data = value;
              },
            );
          });
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
          ),
          child: Icon(size: 45, Icons.refresh),
        ),
      ),
      appBar: MyAppBar(() {}, "STOCK", args, false),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600),
                "Tourets Vides Montés :",
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(25.0, 10, 10, 10),
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          '',
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Cerclé',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Non Cerclé',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'G',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['G']['stock_monte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['G']['stock_monte_non_cercle']
                                .toString()))),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'H',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['H']['stock_monte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['H']['stock_monte_non_cercle']
                                .toString()))),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            ' I',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['I']['stock_monte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['I']['stock_monte_non_cercle']
                                .toString()))),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600),
                "Tourets Vides Démontés :",
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(25.0, 10, 10, 10),
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          '',
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Cerclé',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Non Cerclé',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'G',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['G']['stock_demonte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['G']['stock_demonte_non_cercle']
                                .toString()))),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'H',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['H']['stock_demonte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['H']['stock_demonte_non_cercle']
                                .toString()))),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            ' I',
                          ),
                        ),
                        DataCell(Center(
                            child: Text(
                                data['I']['stock_demonte_cercle'].toString()))),
                        DataCell(Center(
                            child: Text(data['I']['stock_demonte_non_cercle']
                                .toString()))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
