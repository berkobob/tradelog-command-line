import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';
import 'package:intl/intl.dart';

const root = 'http://localhost';
const port = '8888';
const headers = {'Content-Type': 'application/json'};

enum Url {
  home(''),
  trades('trades'),
  positions('positions'),
  stocks('stocks'),
  portfolios('portfolios'),
  dividends('dividends');

  const Url(this.name);

  final String name;

  Uri get uri => Uri.parse('$root:$port/$name');

  List get all => Url.values.map((x) => {x.name: x.uri}).toList();

  Uri url(String query) => Uri.parse('$root:$port/$name$query');
}

typedef Json = Map<String, dynamic>;

final uris = <String, Uri>{
  Url.home.name: Url.home.uri,
  Url.trades.name: Url.trades.uri,
  Url.positions.name: Url.positions.uri,
  Url.stocks.name: Url.stocks.uri,
  Url.portfolios.name: Url.portfolios.uri,
  Url.dividends.name: Url.dividends.uri,
};

final urls = <String, Url>{
  Url.home.name: Url.home,
  Url.trades.name: Url.trades,
  Url.positions.name: Url.positions,
  Url.stocks.name: Url.stocks,
  Url.portfolios.name: Url.portfolios,
  Url.dividends.name: Url.dividends,
};

final DateFormat date = DateFormat('dd/MM/yyyy');

final moneyFormat = NumberFormat.currency(customPattern: "#,##0.00");

void printJson(Json data, {indent = 0}) {
  data.forEach((key, value) {
    String tabs = key.length < 12
        ? key.length < 8
            ? '\t\t'
            : '\t'
        : '';

    switch (value.runtimeType) {
      case DateTime:
        print('${" " * indent}${yellow(key)}: $tabs${date.format(value)}');
        break;
      case double:
        print('${" " * indent}${yellow(key)}: '
            '$tabs${moneyFormat.format(value)}');
        break;
      case int:
        print('${" " * indent}${yellow(key)}: $tabs$value');
        break;
      case (bool):
        print('${" " * indent}${yellow(key)}: $tabs'
            ' ${value ? green('TRUE') : red('FALSE')}');
        break;
      case (String):
        print('${" " * indent}${yellow(key)}: $tabs'
            '${value.contains('ERROR') ? red(value, bold: true) : value}');
        break;
      case Null:
        // print('${" " * indent}${yellow(key)}:');
        break;
      case List:
        print('${" " * indent}${yellow(key)}:$tabs$value');
        // print('${" " * indent}${yellow(key)}:$tabs${key == 'stocks'
        //     '' ? value : '${value.length}'}');
        break;
      default:
        print('${" " * indent}${yellow(key)}: {');
        printJson(value, indent: indent + 3);
        print('${" " * indent}}');
        break;
    }
  });
}

///
/// A stream transformer to convert a list of comma separated fields to a map
///
class MyTransformer extends StreamTransformerBase<List<String>, Json> {
  @override
  Stream<Json> bind(Stream<List<String>> stream) async* {
    var header = <String>[];
    await for (var row in stream) {
      if (header.isEmpty) {
        header = row;
      } else {
        yield Json.fromIterables(header, row);
      }
    }
  }
}

Future<List> load(String fileName) async => await File(fileName)
    .openRead()
    .transform(utf8.decoder)
    .map((element) => element.replaceAll('"', ''))
    .transform(LineSplitter())
    .map((element) => element.split(','))
    .transform(MyTransformer())
    .toList();

List checkPortfolio(List items) {
  if (items[0].keys.contains('portfolio')) return items;
  final port = Input(prompt: 'Portfolio name missing.').interact();
  for (var item in items) {
    item['Portfolio'] = port;
  }
  print(items);
  return items;
}
