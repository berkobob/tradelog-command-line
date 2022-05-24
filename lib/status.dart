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
    print(await status());
  }

  Future<String> status() async {
    try {
      final then = DateTime.now();
      final response = await get(Url.home.uri);
      final time = DateTime.now().difference(then);
      return green('Server status on ${Url.home.uri}: ${response.reasonPhrase} '
          '(${response.statusCode}) in ${time.inMilliseconds} milliseconds.');
    } catch (e) {
      return red("Trade log server not available on ${Url.home.uri} - "
          "please try again later");
    }
  }
}
