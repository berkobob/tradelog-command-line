import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tlc/get.dart';

main() {
  test('Expect a list', () async {
    final data = await Get().fetch('trades');
    expect(data, isA<List>());
  });
}
