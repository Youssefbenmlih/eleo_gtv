// ignore_for_file: non_constant_identifier_names

class ChargementModel {
  late int user_id;
  late String date;
  late List<ChargementListElement> list;
  late int tare_total;

  ChargementModel({
    required this.user_id,
    required this.date,
    required this.list,
    required this.tare_total,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'date': date,
      'list': list,
      'tare_total': tare_total,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'touret_type': touret_type,
      'quantite_joues': quantite_joues,
      'cercle': cercle,
      'ingelec': ingelec,
      'Tare': Tare,
    };
  }
}
