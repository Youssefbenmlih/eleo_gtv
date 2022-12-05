// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:front/models/chargement_model.dart';
import 'package:front/models/demontage_model.dart';
import 'package:front/models/reception_model.dart';

class ActivitySummary extends StatelessWidget {
  bool is_dem;
  bool is_rec;

  List res;

  ActivitySummary({
    Key? key,
    required this.is_dem,
    required this.is_rec,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map nbt = {
      'G': [0, 0],
      'H': [0, 0],
      'I': [0, 0]
    };
    if (is_dem) {
      res = res as List<DemontageListElement>;
      ;
      for (DemontageListElement el in res) {
        nbt[el.touret_type][el.cercle == "o" ? 0 : 1] += el.quantite_tourets;
      }
    } else if (is_rec) {
      res = res as List<ReceptionListElement>;
      for (ReceptionListElement el in res) {
        nbt[el.touret_type][el.cercle == "o" ? 0 : 1] += el.quantite_tourets;
      }
    } else {
      res = res as List<ChargementListElement>;
      for (ChargementListElement el in res) {
        nbt[el.touret_type][el.cercle == "o" ? 0 : 1] += el.quantite_joues;
      }
    }

    String t = "Tourets";
    String j = "Joues";

    return SizedBox(
      height: 200,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                style: Theme.of(context).textTheme.headlineMedium,
                "Nombre de ${(is_dem || is_rec) ? t : j} :",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      style: Theme.of(context).textTheme.headlineMedium,
                      "Cerclé",
                    ),
                    Text(
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      """G : ${nbt['G'][0]}
H : ${nbt['H'][0]}
I : ${nbt['I'][0]}""",
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      style: Theme.of(context).textTheme.headlineMedium,
                      "Non Cerclé",
                    ),
                    Text(
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      """G : ${nbt['G'][1]}
H : ${nbt['H'][1]}
I : ${nbt['I'][1]}""",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
