import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'dir.dart';

class Dividend extends Command {
  @override
  final name = 'dividend';
  @override
  final description = 'Read a file of dividends and send them to tradelog';

  Dividend() {
    argParser
      ..addOption('filename',
          abbr: 'f',
          help: 'The relative path the csv dividend file',
          defaultsTo: '')
      ..addFlag('wait',
          abbr: 'w', help: 'Wait for the user input between dividends')
      ..addFlag('quiet', abbr: 'q', help: 'Only display success. No details');
  }

  @override
  Future<List> run([String? fileName]) async {
    String? file = argResults?['filename'] ?? fileName;
    if (file == null) return [];
    if (file != '' && !exists(file)) {
      print(yellow('File $file cannot be found.'));
      return [];
    }

    final data = await load(file == '' ? Dir.fileName : file);
    final divis = checkPortfolio(data);

    for (Json divi in divis) {
      final body = json.encode(divi);
      final res = await post(Url.dividends.uri, headers: headers, body: body);
      final reply = json.decode(res.body) as Json;
      argResults?['quiet']
          ? print('Success: ${reply['ok'] ? green('YES') : red('FAIL')}')
          : printJson(reply);
      if (argResults?['wait'] != null &&
          argResults?['wait'] &&
          divis.indexOf(divi) < divis.length - 1) {
        confirm('Process next dividend...', defaultValue: true);
      }
    }
    return divis;
  }
}
