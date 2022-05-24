import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tlc/dir.dart';

main() {
  test('Expect a list of file names', () {
    final result = Dir().getFileNames();
    expect(result, isA<List>());
  });
}
