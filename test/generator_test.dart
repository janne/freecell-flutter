import 'package:flutter_test/flutter_test.dart';
import 'package:freecell/generator.dart';

void main() {
  final generator = Generator(1);
  for (var n in <int>[41, 18467, 6334, 26500, 19169]) {
    test('Generates number $n', () {
      expect(generator.next(), n);
    });
  }
}
