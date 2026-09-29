import 'dart:math';

String generateId() {
  final random = Random();
  return List.generate(
    10,
    (_) => String.fromCharCode(random.nextInt(26) + 97),
  ).join();
}