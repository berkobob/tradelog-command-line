export 'package:dcli/dcli.dart';

import '../constants.dart';
export '../constants.dart';

abstract class BaseModel {
  dynamic id;
  String portfolio;
  double proceeds;
  double commission;
  double cash;
  double risk;
  int quantity = 0;

  BaseModel(Json json)
      : id = json['_id'],
        portfolio = json['portfolio'],
        proceeds = json['proceeds'],
        commission = json['commission'],
        cash = json['cash'],
        risk = json['risk'] == 1234567.89 ? double.infinity : json['risk'],
        quantity = json['quantity'];

  String get header;
  Json toJson();
}
