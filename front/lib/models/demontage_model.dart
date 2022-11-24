// ignore_for_file: non_constant_identifier_names

class DemontageModel {
  late int user_id;
  late DateTime date;
  late List<DemontageListElement> list;

  DemontageModel({
    required this.user_id,
    required this.date,
    required this.list,
  });
}

class DemontageListElement {
  late String touret_type;
  late int quantite_tourets;
  late String cercle;
  late String ingelec;

  DemontageListElement({
    required this.touret_type,
    required this.quantite_tourets,
    required this.cercle,
    required this.ingelec,
  });
}
