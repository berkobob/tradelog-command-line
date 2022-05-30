import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:http/http.dart';
import 'package:tlc/models/base_model.dart';

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
      ..addFlag('pretty', abbr: 'p', help: 'Pretty flag fromats output')
      ..addMultiOption('query',
          abbr: 'q',
          help: 'Constrain your search'
              'with criteria e.g. stock=APPL',
          defaultsTo: ['missing']);
  }

  @override
  void run() async {
    final data = await fetch(argResults?.command?.name);
    if (data == null || data.isEmpty) {
      echo(yellow('Your search'), newline: false);
      echo(white(' "${argResults?.arguments.join(' ')}" '), newline: false);
      print(yellow('did not retrieve any resutls.'));
      return;
    }

    if (argResults?['pretty']) {
      JsonEncoder encoder = JsonEncoder.withIndent(('  '));
      for (var e in data) {
        print(encoder.convert(e.toJson()));
      }
    } else {
      print(data[0].header);
      for (var e in data) {
        print('$e');
      }
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
    final response = await get(url, headers: headers);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      return null;
    }

    final data = json.decode(response.body);

    switch (cmd) {
      case 'portfolios':
        return data['msg'].map<BaseModel>((port) => Portfolio(port)).toList();
      case 'positions':
        return data['msg'].map<BaseModel>((posn) => Position(posn)).toList();
      case 'stocks':
        return data['msg'].map<BaseModel>((stock) => Stock(stock)).toList();
      case 'trades':
        return data['msg'].map<BaseModel>((trade) => Trade(trade)).toList();
      default:
        return null;
    }
  }
}
