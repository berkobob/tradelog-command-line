import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'dir.dart';

class Trade extends Command {
  @override
  final name = 'trade';
  @override
  final description =
      'Read a csv file of raw trades and send them to the tradelog';

  Trade() {
    argParser
      ..addOption('filename',
          abbr: 'f',
          help: 'The relative path to the csv trade file',
          defaultsTo: '')
      ..addFlag('wait', abbr: 'w', help: 'Wait for user input between trades');
  }

  @override
  Future<List> run([String? fileName]) async {
    String? file = argResults?['filename'] ?? fileName;
    if (file == null) return [];
    if (file != '' && !exists(file)) {
      print(yellow('File $file does not exist.'));
      return [];
    }

    final trades = await load(file == '' ? Dir.fileName : file);
    trades.sort((a, b) =>
        (int.parse(a['TradeDate'])).compareTo(int.parse(b['TradeDate'])));

    for (Json trade in trades) {
      final body = json.encode(trade);
      final res = await post(Url.trades.uri, headers: headers, body: body);
      final reply = json.decode(res.body) as Json;
      printJson(reply);
      if (argResults?['wait'] != null &&
          argResults!['wait'] &&
          trades.indexOf(trade) < trades.length - 1) {
        confirm('Process next trade', defaultValue: true);
      }
    }
    return trades;
  }

  Future<List> load(String fileName) async => await File(fileName)
      .openRead()
      .transform(utf8.decoder)
      .map((element) => element.replaceAll('"', ''))
      .transform(LineSplitter())
      .map((element) => element.split(','))
      .transform(MyTransformer())
      .toList();
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
