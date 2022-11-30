// ignore_for_file: file_names, non_constant_identifier_names

import 'package:front/models/chargement_model.dart';
import 'package:front/models/demontage_model.dart';
import 'package:front/models/reception_model.dart';

class HistoriqueModel {
  late String user_name;
  late DateTime date;
  late List<HistoriqueListElement> list;
  late String activity_name;
  late String activity_id;
  late int? tare;
  late int id;

  HistoriqueModel({
    required this.user_name,
    required this.date,
    required this.list,
    required this.activity_name,
    required this.activity_id,
    required this.id,
    this.tare,
  });
}

class HistoriqueListElement {
  late List<DemontageListElement> list_dem;
  late List<ChargementListElement> list_charg;
  late List<ReceptionListElement> list_rec;

  HistoriqueListElement({
    required this.list_dem,
    required this.list_charg,
    required this.list_rec,
  });
}
