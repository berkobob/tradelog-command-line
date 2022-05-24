import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';

class Dir extends Command {
  @override
  final name = 'dir';
  @override
  final description = 'Return a list of .csv files in the current directory';

  static String get fileName {
    final files = Dir().getFileNames();
    return files[Select(
            prompt: 'Select which file to process',
            options: files,
            initialIndex: 0)
        .interact()];
  }

  @override
  List<String> run() {
    final result = getFileNames();
    print(blue('Found ${result.length} csv files:'));
    for (var i in result) {
      print(cyan('\t${result.indexOf(i)}: $i'));
    }
    return result;
  }

  List<String> getFileNames() {
    return find('*.csv', recursive: true)
        .toList()
        .map((file) => relative(file))
        .toList();
  }
}
