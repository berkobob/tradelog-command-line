// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dcli/dcli.dart';
export 'package:dcli/dcli.dart';

import 'position.dart';
import 'trade.dart';
import '../constants.dart';
export '../constants.dart';

abstract class BaseModel with Comparable<BaseModel> {
  dynamic id;
  String portfolio;
  double proceeds;
  double commission;
  double cash;
  double risk;
  num quantity = 0;

  BaseModel(Json json)
      : id = json['_id'],
        portfolio = json['portfolio'],
        proceeds = json['proceeds'],
        commission = json['commission'],
        cash = json['cash'],
        risk = json['risk'],
        quantity = json['quantity'];

  Json toJson();

  @override
  String toString() {
    final data = toJson();
    return data.keys.reduce((string, key) {
      if (string == data.keys.first) string = _format(data.values.first);
      if (key == 'description' && this is Position) return string;
      if (key == 'symbol' &&
          data[key].length < 5 &&
          (this is Position || this is Trade)) data[key] += ' ' * 10;
      return '$string\t${_format(data[key])}';
    });
  }

  String get header {
    final data = toJson();
    final string = data.keys.reduce((string, key) {
      if (string == data.keys.first)
        string = string.padRight(_format(data[string], pad: true));
      return (key == 'description' && this is Position)
          ? string
          : data[key] is String
              ? key == 'symbol' &&
                      data[key].length < 5 &&
                      (this is Position || this is Trade)
                  ? '$string\t${key.padRight(_format(data[key] + ' ' * 10, pad: true))}'
                  : '$string\t${key.padRight(_format(data[key], pad: true))}'
              : '$string\t${key.padLeft(_format(data[key], pad: true))}';
    });
    return black(string.toUpperCase(), background: AnsiColor.white, bold: true);
  }

  dynamic _format(dynamic value, {pad = false}) {
    if (value == null || value == 'null') return pad ? 10 : ''.padLeft(10);

    if (value is int) return pad ? 10 : value.toString().padLeft(10);

    if (value is List) return pad ? 10 : value.length.toString().padLeft(10);

    if (value is double) {
      if (pad) return 12;
      if (value < 0.01 && value > -0.01) return '    '.padLeft(12);
      if (value < 0) return red(moneyFormat.format(value).padLeft(12));
      return white(moneyFormat.format(value).padLeft(12), bold: true);
    }

    if (value.contains('00:00.000Z'))
      return pad
          ? 12
          : value.replaceRange(10, date.toString().length, ' ').padRight(12);

    if (value.length > 25)
      return pad
          ? 25
          : value.replaceRange(20, value.length, '...').padRight(25);

    if (value.length > 12) return pad ? 25 : value.padRight(25);

    return pad ? 10 : value.padRight(10);
  }
}
