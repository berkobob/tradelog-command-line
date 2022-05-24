import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart';
import 'package:interact/interact.dart';

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
          abbr: 'f', help: 'The relative path to the csv trade file')
      ..addFlag('pretty', abbr: 'p', help: 'Pretty flag fromats output');
  }

  @override
  run() async {
    String? file = argResults?['filename'];
    if (file != null && !exists(file)) {
      print(yellow('File $file does not exist.'));
      file = null;
    }

    if (argResults?['pretty']) {
      await prettyTrade(file ?? Dir.fileName);
    } else {
      await trade(file ?? Dir.fileName);
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

  Future<void> prettyTrade(String fileName) async {
    final trades = await load(fileName);
    final spinners = MultiSpinner();
    for (var trade in trades) {
      String? msg;
      Json result = {};
      final spinner = spinners.add(Spinner(
          icon: green('➜'),
          leftPrompt: (done) => '', // prompts are optional
          rightPrompt: (done) => done
              ? msg == null
                  ? _row(result)
                  : msg!
              : '${trade['Quantity']} ${trade['Description']}'));

      final body = json.encode(trade);
      post(Url.trades.uri, headers: headers, body: body).then((res) {
        result = json.decode(res.body);
        msg = null;
      }).onError((error, stackTrace) {
        msg = '$error';
      }).whenComplete(() => spinner.done());
    }
  }

  Future<List> trade(String fileName) async {
    final trades = await load(fileName);
    final results = [];
    for (var trade in trades) {
      final body = json.encode(trade);
      final res = await post(Url.trades.uri, headers: headers, body: body);
      results.add(json.decode(res.body));
    }
    return results;
  }

  String _row(Json trade) => Format().row([
        trade['msg']['trade']['symbol'],
        trade['msg']['stock']['stock'],
        trade['msg']['position']['description']
      ], widths: [
        15,
        15,
        15
      ]);
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
