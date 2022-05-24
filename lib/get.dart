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
      ..addFlag('pretty', abbr: 'p', help: 'Pretty flag fromats output');
  }

  @override
  void run() async {
    final data = await fetch(argResults?.command?.name);

    if (argResults?['pretty']) {
      JsonEncoder encoder = JsonEncoder.withIndent(('  '));
      data?.forEach((e) => print(encoder.convert(e.toJson())));
    } else {
      final header = (data?[0] as BaseModel);
      print(header.header);
      data?.forEach((element) {
        print(element.toString());
      });
    }
  }

  Future<List<BaseModel>?> fetch(String? cmd) async {
    if (cmd == null) {
      print(yellow('Cannot get '
          '"${argResults!.rest.isEmpty ? '' : argResults!.rest.first}".'));
      return null;
    }

    final response = await get(urls[cmd]!, headers: headers);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      return null;
    }

    final data = json.decode(response.body);
    if (!data['ok']) {
      print(data['msg']);
      return null;
    }

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
