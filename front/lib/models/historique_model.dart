// ignore_for_file: file_names, non_constant_identifier_names

import 'package:front/models/chargement_model.dart';
import 'package:front/models/demontage_model.dart';
import 'package:front/models/reception_model.dart';

class HistoriqueModel {
  late int user_id;
  late String date;
  late List<HistoriqueListElement> list;
  late int activity_name;

  HistoriqueModel({
    required this.user_id,
    required this.date,
    required this.list,
    required this.activity_name,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'date': date,
      'list': list,
      'activity_name': activity_name,
    };
  }
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
