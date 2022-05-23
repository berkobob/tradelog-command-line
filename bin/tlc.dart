import 'package:args/command_runner.dart';

import 'dir.dart';
import 'status.dart';
import 'trade.dart';

void main(List<String> args) {
  CommandRunner runner = CommandRunner('tlc', 'Tradelog command line app.')
    ..addCommand(Dir())
    ..addCommand(Status())
    ..addCommand(Trade());

  runner.run(args);
}
