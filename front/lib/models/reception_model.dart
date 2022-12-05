// ignore_for_file: non_constant_identifier_names

class ReceptionModel {
  late int user_id;
  late String date;
  late List<ReceptionListElement> list;

  ReceptionModel({
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

class ReceptionListElement {
  late String touret_type;
  late String cercle;
  late String ingelec;
  late String numero_de_lot;
  late int quantite_tourets;

  ReceptionListElement({
    required this.touret_type,
    required this.numero_de_lot,
    required this.cercle,
    required this.ingelec,
    required this.quantite_tourets,
  });

  Map<String, dynamic> toJson() {
    return {
      'touret_type': touret_type,
      'numero_de_lot': numero_de_lot,
      'cercle': cercle,
      'ingelec': ingelec,
      'quantite_tourets': quantite_tourets,
    };
  }
}
