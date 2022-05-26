import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tlc/trade.dart';

main() {
  test('Expect a list of processed trades', () async {
    final result = await Trade().run('data/test1.csv');
    expect(result, isA<List>());
  });
}
