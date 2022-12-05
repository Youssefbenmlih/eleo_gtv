// ignore_for_file: non_constant_identifier_names

class InventaireModel {
  late int user_id;
  late String date;
  late String type_touret;
  late int nb_monte_cercle;
  late int nb_monte_non_cercle;
  late int nb_demonte_cercle;
  late int nb_demonte_non_cercle;
  late int stock_avant;
  late int stock_apres;

  InventaireModel({
    required this.user_id,
    required this.date,
    required this.type_touret,
    required this.nb_monte_cercle,
    required this.nb_demonte_cercle,
    required this.nb_monte_non_cercle,
    required this.nb_demonte_non_cercle,
    required this.stock_avant,
    required this.stock_apres,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "user_id": user_id,
      "type_touret": type_touret,
      "nb_monte_cercle": nb_monte_cercle,
      "nb_demonte_cercle": nb_demonte_cercle,
      "nb_monte_non_cercle": nb_monte_non_cercle,
      "nb_demonte_non_cercle": nb_demonte_non_cercle,
      "stock_avant": stock_avant,
      "stock_apres": stock_apres,
    };
  }
}
