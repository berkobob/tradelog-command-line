import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart';

import 'constants.dart';

class Status extends Command {
  @override
  final name = 'status';
  @override
  final description = 'Check the status of the Trade Log Server';

  @override
  run() async {
    try {
      final response = await get(Url.home.uri);
      print(green('Server status on ${Url.home.url}: ${response.reasonPhrase} '
          '(${response.statusCode})'));
    } catch (e) {
      print(red("Trade log server not available on ${Url.home.url} - "
          "please try again later"));
    }
  }
}
