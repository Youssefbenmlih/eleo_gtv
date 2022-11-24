// ignore_for_file: non_constant_identifier_names

class DemontageModel {
  late int user_id;
  late String date;
  late List<DemontageListElement> list;

  DemontageModel({
    required this.user_id,
    required this.date,
    required this.list,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'date': date,
      'list': list,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'touret_type': touret_type,
      'quantite_tourets': quantite_tourets,
      'cercle': cercle,
      'ingelec': ingelec,
    };
  }
}
