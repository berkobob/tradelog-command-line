import 'dart:convert';
import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart' hide Progress;
import 'package:interact/interact.dart';
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
      ..addFlag('wait', abbr: 'w', help: 'Wait for user input between trades')
      ..addOption('verbose',
          abbr: 'v',
          help: 'Display more info about each trade',
          allowed: ["errors", "quiet", "normal", "json"],
          allowedHelp: {
            "quiet": "Do not display any results",
            "errors": "Only show errors",
            "all": "Show full error but only one line for successful trades",
            "json": "Show all details in json format",
          },
          defaultsTo: "errors")
      ..addOption('portfolio', abbr: 'p', help: 'Add trades to this portfolio');
  }

  @override
  Future<List> run([String? fileName]) async {
    bool wait = argResults?['wait'] ?? false;
    String? file = argResults?['filename'] ?? fileName;
    String? port = argResults?['portfolio'];
    String verbose = argResults?['verbose'];

    if (file == null) return [];
    if (file != '' && !exists(file)) {
      print(yellow('File $file does not exist.'));
      return [];
    }

    final data = await load(file == '' ? Dir.fileName : file);

    data.sort((a, b) =>
        (int.parse(a['TradeDate'])).compareTo(int.parse(b['TradeDate'])));
    final trades = checkPortfolio(data, port);

    var bar = Progress(
        length: trades.length,
        leftPrompt: (_) => trades.length.toString(),
        rightPrompt: (progress) => progress.toString());

    ProgressState? progress;
    if (verbose == 'quiet' || verbose == 'errors') progress = bar.interact();

    for (Json trade in trades) {
      final body = json.encode(trade);
      final res = await post(Url.trades.uri, headers: headers, body: body);
      final reply = json.decode(res.body) as Json;

      switch (verbose) {
        case "quiet":
          break;
        case "errors":
          if (!reply['ok']) printJson(reply);
          break;
        case "all":
          reply['ok'] ? print('Success: ${green('YES')}') : printJson(reply);
          break;
        case "json":
          printJson(reply);
          break;
      }
      if (wait && trades.indexOf(trade) < trades.length - 1) {
        wait = confirm('Continue waiting...', defaultValue: true);
      } else if (verbose == 'quiet' || verbose == 'errors') {
        progress?.increase(1);
      }
    }
    if (verbose == 'quiet' || verbose == 'errors') progress?.done();
    return trades;
  }
}
