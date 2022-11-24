// ignore_for_file: non_constant_identifier_names

class ReceptionModel {
  late int user_id;
  late DateTime date;
  late List<ReceptionListElement> list;

  ReceptionModel({
    required this.user_id,
    required this.date,
    required this.list,
  });
}

class ReceptionListElement {
  late String touret_type;
  late String cercle;
  late String ingelec;
  late String numero_de_lot;

  ReceptionListElement({
    required this.touret_type,
    required this.numero_de_lot,
    required this.cercle,
    required this.ingelec,
  });
}
