// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:front/models/chargement_model.dart';
import 'package:front/models/demontage_model.dart';
import 'package:front/models/reception_model.dart';
import 'package:front/widgets/chargement_list.dart';
import 'package:front/widgets/reception_list.dart';

import 'demontage_list.dart';

class DetailList extends StatelessWidget {
  bool is_dem;
  bool is_rec;

  List res;

  DetailList({
    Key? key,
    required this.is_dem,
    required this.is_rec,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (is_dem) {
      return DemontageList(
        delete: false,
        elements: res as List<DemontageListElement>,
        deleteTx: () {},
      );
    } else if (is_rec) {
      return receptionList(
        delete: false,
        elements: res as List<ReceptionListElement>,
        deleteTx: () {},
      );
    }
    return chargementList(
      delete: false,
      elements: res as List<ChargementListElement>,
      deleteTx: () {},
    );
  }
}
