import 'package:flutter/material.dart';
import 'package:front/widgets/my_app_bar.dart';

class Stock extends StatelessWidget {
  const Stock({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final mapArgs = args as Map;
    var id = mapArgs['id'];
    return Scaffold(
      appBar: MyAppBar(() {}, "STOCK", args),
    );
  }
}
