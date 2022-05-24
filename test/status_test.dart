import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tlc/status.dart';

main() {
  test('Expect a string from status command', () async {
    final result = await Status().status();
    expect(result, isA<String>());
  });
}
