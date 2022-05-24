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
        risk = json['risk'],
        quantity = json['quantity'];

  List get row => [
        portfolio,
        proceeds.toStringAsFixed(2),
        commission.toStringAsFixed(2),
        cash.toStringAsFixed(2),
        risk.toStringAsFixed(2),
        quantity.toString().padLeft(10),
      ];

  String get header => '';
  Json toJson();
}
