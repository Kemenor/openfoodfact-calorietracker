import 'package:calorie_tracker/domain/search_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('splits into lowercase tokens', () {
    expect(searchTokens('Olive Oil'), ['olive', 'oil']);
    expect(searchTokens('Tomatoes, red, ripe'), ['tomatoes', 'red', 'ripe']);
  });

  test('applies produce synonyms', () {
    expect(searchTokens('bell pepper'), ['peppers', 'sweet']);
    expect(searchTokens('rocket'), ['arugula']);
    expect(searchTokens('cherry tomato'), ['tomatoes', 'red', 'ripe']);
    expect(searchTokens('courgette'), ['zucchini']);
  });

  test('empty / whitespace yields no tokens', () {
    expect(searchTokens('   '), isEmpty);
    expect(searchTokens(''), isEmpty);
  });
}
