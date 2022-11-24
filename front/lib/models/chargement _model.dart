// ignore_for_file: non_constant_identifier_names

class ChargementModel {
  late int user_id;
  late DateTime date;
  late List<ChargementListElement> list;

  ChargementModel({
    required this.user_id,
    required this.date,
    required this.list,
  });
}

class ChargementListElement {
  late String touret_type;
  late int quantite_joues;
  late String cercle;
  late String ingelec;
  late int Tare;

  ChargementListElement({
    required this.touret_type,
    required this.quantite_joues,
    required this.cercle,
    required this.ingelec,
    required this.Tare,
  });
}
