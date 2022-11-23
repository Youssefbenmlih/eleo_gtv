// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../widgets/gradient_elevated.dart';
import '../widgets/navigation_drawer.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class HomePage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print(args);

    final appbar = NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.indigo,
        ],
      ),
      centerTitle: true,
      title: Text(style: Theme.of(context).textTheme.titleLarge, "ACCUEIL"),
    );

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: appbar,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 36, 18, 18),
                child: SizedBox(
                    height: 150,
                    width: 350,
                    child: Image.asset(
                      "assets/images/logo_eleo.png",
                      fit: BoxFit.none,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
                "Choisissez votre activité :",
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyElevatedButton(
                  height: 80,
                  width: 350,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(40),
                  child: Text(
                      style: Theme.of(context).textTheme.titleLarge,
                      'Scan réception Tourets Vides'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyElevatedButton(
                  height: 80,
                  width: 350,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(40),
                  child: Text(
                      style: Theme.of(context).textTheme.titleLarge,
                      'Chargement Tourets Démontés'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyElevatedButton(
                  height: 80,
                  width: 350,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(40),
                  child: Text(
                      style: Theme.of(context).textTheme.titleLarge,
                      'Démontage Tourets'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyElevatedButton(
                  height: 80,
                  width: 350,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(40),
                  child: Text(
                      style: Theme.of(context).textTheme.titleLarge,
                      'Inventaire'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
