import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:http/http.dart';
import 'package:tlc/models/base_model.dart';
import 'package:tlc/models/dividend.dart';

import 'models/models.dart';

class Get extends Command {
  @override
  final name = 'get';
  @override
  final description = 'Requests trades from the Trade Log Server';

  Get() {
    argParser
      ..addCommand('trades')
      ..addCommand('positions')
      ..addCommand('stocks')
      ..addCommand('portfolios')
      ..addCommand('dividends')
      ..addOption('print',
          abbr: 'p',
          help: 'Define the type of output',
          allowed: ['csv', 'json', 'table', 'plane'],
          allowedHelp: {
            'csv': 'Data in csv format for spreadsheets',
            'json': 'Data in Json format',
            'table': 'Data in pretty tables'
          },
          defaultsTo: "table")
      ..addMultiOption('query',
          abbr: 'q',
          help: 'Constrain your search'
              'with criteria e.g. stock=APPL');
  }

  @override
  void run() async {
    final data = await fetch(argResults?.command?.name)
      ?..sort();

    if (data == null) return;
    if (data.isEmpty) {
      echo(yellow('Your search'), newline: false);
      echo(white(' "${argResults?.arguments.join(' ')}" '), newline: false);
      print(yellow('did not retrieve any ${argResults?.command?.name}.'));
      return;
    }

    final json = data.map((e) => e.toJson()).toList();

    switch (argResults?['print']) {
      case 'json':
        for (var item in json) {
          printJson(item);
        }
        break;
      case 'csv':
        for (var trade in json) {
          print(trade.values.reduce((value, element) => '$value,$element'));
        }
        break;
      case 'table':
        print(data[0].header);
        for (var e in data) {
          print('$e');
        }
        break;
      case 'plane':
        JsonEncoder encoder = JsonEncoder.withIndent(('  '));
        for (var e in data) {
          print(encoder.convert(e));
        }
        break;
    }
  }

  Future<List<BaseModel>?> fetch(String? cmd) async {
    if (cmd == null) {
      print(yellow('Cannot get '
          '"${argResults!.rest.isEmpty ? '' : argResults!.rest.first}".'));
      return null;
    }

    String query = argResults?['query'].join('&');
    final url = query == '' ? urls[cmd]!.uri : urls[cmd]!.url('?$query');
    Response response;
    try {
      response = await get(url, headers: headers);
      if (response.statusCode != 200) {
        throw (response.reasonPhrase.toString());
      }
    } catch (e) {
      print(red('Trade Log may be unavailable!'));
      print('Try running "tlc status"');
      print(red('Err msg: $e'));
      return null;
    }

    final data = json.decode(response.body);

    switch (cmd) {
      case 'portfolios':
        return data['portfolios']
            .map<BaseModel>((port) => Portfolio(port))
            .toList();
      case 'positions':
        return data['positions']
            .map<BaseModel>((posn) => Position(posn))
            .toList();
      case 'stocks':
        return data['stocks'].map<BaseModel>((stock) => Stock(stock)).toList()
          ..sort();
      case 'trades':
        return data['trades'].map<BaseModel>((trade) => Trade(trade)).toList();
      case 'dividends':
        return data['dividends']
            .map<BaseModel>((divi) => Dividend(divi))
            .toList();
      default:
        return null;
    }
  }
}
