import 'package:args/command_runner.dart';
import 'package:tlc/dir.dart';
import 'package:tlc/get.dart';
import 'package:tlc/status.dart';
import 'package:tlc/trade.dart';

void main(List<String> args) {
  CommandRunner runner = CommandRunner('tlc', 'Tradelog command line app.')
    ..addCommand(Dir())
    ..addCommand(Status())
    ..addCommand(Get())
    ..addCommand(Trade());

  runner.run(args);
}
