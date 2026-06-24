import 'dart:math';

class RandomUtils {
  RandomUtils._();

  static final Random _random = Random();

  static int nextInt(int min, int max) => min + _random.nextInt(max - min + 1);

  static double nextDouble(double min, double max) =>
      min + _random.nextDouble() * (max - min);

  static T pick<T>(List<T> items) => items[_random.nextInt(items.length)];

  static bool chance(double probability) => _random.nextDouble() < probability;

  static List<T> shuffle<T>(List<T> items) {
    final copy = List<T>.from(items);
    copy.shuffle(_random);
    return copy;
  }
}
